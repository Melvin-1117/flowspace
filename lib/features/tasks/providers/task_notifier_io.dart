import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/task.dart';
import '../../../core/models/task_activity.dart';
import '../../../core/providers/isar_provider.dart';
import 'task_providers.dart';

class TaskNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final isar = await ref.watch(isarProvider.future);
    final tasks = await _loadTasks(isar);
    final activities = await isar
        .collection<TaskActivity>()
        .where()
        .sortByTimestamp()
        .findAll();
    ref.read(taskActivitiesProvider.notifier).state = _groupActivities(
      activities,
    );
    return tasks;
  }

  Future<void> addTask(Task task) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.collection<Task>().put(task);
    });
    await _reloadFromDb(isar);
    await _appendActivity(task.uuid, 'created', 'Task created');
    _pushNotification(task.uuid, 'upcoming', 'Task added', task.title);
  }

  Future<void> updateTask(Task task) async {
    final isar = await ref.read(isarProvider.future);
    task.updatedAt = DateTime.now();
    await isar.writeTxn(() async {
      await isar.collection<Task>().put(task);
    });
    await _reloadFromDb(isar);
    await _appendActivity(task.uuid, 'edited', 'Task updated');
  }

  Future<void> deleteTask(String uuid) async {
    final isar = await ref.read(isarProvider.future);
    final task = _taskByUuid(uuid);
    if (task == null) return;

    await isar.writeTxn(() async {
      await isar.collection<Task>().delete(task.id);
      final activities = await isar
          .collection<TaskActivity>()
          .where()
          .sortByTimestamp()
          .findAll();
      final toDelete = activities
          .where((item) => item.taskId == uuid)
          .map((item) => item.id);
      for (final id in toDelete) {
        await isar.collection<TaskActivity>().delete(id);
      }
    });

    final current = state.valueOrNull ?? const <Task>[];
    final cleaned = current
        .where((item) => item.uuid != uuid)
        .map(
          (item) => item.dependencyIds.contains(uuid)
              ? item.copyWith(
                  dependencyIds: item.dependencyIds
                      .where((dep) => dep != uuid)
                      .toList(),
                  updatedAt: DateTime.now(),
                )
              : item,
        )
        .toList();
    await isar.writeTxn(() async {
      await isar.collection<Task>().putAll(cleaned);
    });

    await _reloadFromDb(isar);
    await _reloadActivities(isar);
  }

  Future<void> moveTask(String uuid, String newStatus) async {
    final task = _taskByUuid(uuid);
    if (task == null) return;
    final updatedTask = task.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    await updateTask(updatedTask);

    await _appendActivity(task.uuid, 'moved', 'Moved to $newStatus');
    if (newStatus == 'done') {
      await _appendActivity(task.uuid, 'completed', 'Task marked complete');
      _pushNotification(task.uuid, 'completed', 'Task completed', task.title);
    }
  }

  Future<void> reorderTask(String uuid, int newIndex) async {
    final current = [...(state.valueOrNull ?? const <Task>[])];
    final oldIndex = current.indexWhere((item) => item.uuid == uuid);
    if (oldIndex < 0 || newIndex < 0 || newIndex >= current.length) return;
    final task = current.removeAt(oldIndex);
    current.insert(newIndex, task);
    state = AsyncData(current);
  }

  Future<void> toggleSubtask(String taskId, int index) async {
    final task = _taskByUuid(taskId);
    if (task == null) return;
    final subtaskCompleted = [...task.subtaskCompleted];
    if (index < 0 || index >= subtaskCompleted.length) return;

    await updateTask(
      task.copyWith(
        subtaskCompleted: [...subtaskCompleted]
          ..[index] = !subtaskCompleted[index],
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> markDone(String uuid) => moveTask(uuid, 'done');

  Future<void> updatePriority(String uuid, String priority) async {
    final task = _taskByUuid(uuid);
    if (task == null) return;
    await updateTask(
      task.copyWith(priority: priority, updatedAt: DateTime.now()),
    );
    await _appendActivity(uuid, 'edited', 'Priority changed to $priority');
  }

  Future<void> updateDependencies(
    String taskId,
    List<String> dependencyIds,
  ) async {
    final task = _taskByUuid(taskId);
    if (task == null) return;
    await updateTask(
      task.copyWith(dependencyIds: dependencyIds, updatedAt: DateTime.now()),
    );
    await _appendActivity(taskId, 'edited', 'Dependencies updated');
  }

  Task makeTask({
    required String title,
    String description = '',
    required String tag,
    String priority = 'med',
    String status = 'todo',
    DateTime? dueDate,
    bool isRecurring = false,
    String recurringFrequency = 'daily',
    bool assignToPomodoro = false,
    List<String> subtasks = const [],
    List<bool> subtaskCompleted = const [],
    List<String> dependencyIds = const [],
    required String projectId,
  }) {
    return Task()
      ..uuid = const Uuid().v4()
      ..title = title
      ..description = description
      ..tag = tag
      ..priority = priority
      ..status = status
      ..dueDate = dueDate
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..isRecurring = isRecurring
      ..recurringFrequency = recurringFrequency
      ..assignToPomodoro = assignToPomodoro
      ..subtasks = subtasks
      ..subtaskCompleted = subtaskCompleted
      ..dependencyIds = dependencyIds
      ..projectId = projectId;
  }

  bool hasCircularDependency(String taskId, String dependencyId) {
    if (taskId == dependencyId) return true;
    final tasks = state.valueOrNull ?? const <Task>[];
    final map = {for (final task in tasks) task.uuid: task.dependencyIds};
    final visited = <String>{};
    bool dfs(String current) {
      if (current == taskId) return true;
      if (visited.contains(current)) return false;
      visited.add(current);
      for (final dep in map[current] ?? const <String>[]) {
        if (dfs(dep)) return true;
      }
      return false;
    }

    return dfs(dependencyId);
  }

  void dismissNotification(String id) {
    final notifications = [...ref.read(notificationsProvider)];
    final index = notifications.indexWhere((n) => n.id == id);
    if (index < 0) return;
    notifications[index] = notifications[index].copyWith(unread: false);
    ref.read(notificationsProvider.notifier).state = notifications;
  }

  Future<void> _appendActivity(
    String taskId,
    String action,
    String description,
  ) async {
    final isar = await ref.read(isarProvider.future);
    final map = {...ref.read(taskActivitiesProvider)};
    final activities = [...(map[taskId] ?? const <TaskActivity>[])];
    final activity = TaskActivity()
      ..taskId = taskId
      ..action = action
      ..description = description
      ..timestamp = DateTime.now();
    await isar.writeTxn(() async {
      await isar.collection<TaskActivity>().put(activity);
    });
    activities.add(activity);
    map[taskId] = activities;
    ref.read(taskActivitiesProvider.notifier).state = map;
  }

  void _pushNotification(
    String taskId,
    String type,
    String title,
    String subtitle,
  ) {
    final current = [...ref.read(notificationsProvider)];
    current.insert(
      0,
      AppNotification(
        id: const Uuid().v4(),
        taskId: taskId,
        type: type,
        title: title,
        subtitle: subtitle,
        timestamp: DateTime.now(),
      ),
    );
    ref.read(notificationsProvider.notifier).state = current;
  }

  Task? _taskByUuid(String uuid) {
    final current = state.valueOrNull ?? const <Task>[];
    for (final task in current) {
      if (task.uuid == uuid) return task;
    }
    return null;
  }

  Future<void> _reloadFromDb(Isar isar) async {
    final tasks = await _loadTasks(isar);
    state = AsyncData(tasks);
  }

  Future<List<Task>> _loadTasks(Isar isar) async {
    final tasks = await isar
        .collection<Task>()
        .where()
        .sortByCreatedAt()
        .findAll();
    tasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return tasks;
  }

  Future<void> _reloadActivities(Isar isar) async {
    final all = await isar
        .collection<TaskActivity>()
        .where()
        .sortByTimestamp()
        .findAll();
    ref.read(taskActivitiesProvider.notifier).state = _groupActivities(all);
  }

  Map<String, List<TaskActivity>> _groupActivities(List<TaskActivity> all) {
    final grouped = <String, List<TaskActivity>>{};
    for (final activity in all) {
      grouped.putIfAbsent(activity.taskId, () => <TaskActivity>[]);
      grouped[activity.taskId]!.add(activity);
    }
    return grouped;
  }
}
