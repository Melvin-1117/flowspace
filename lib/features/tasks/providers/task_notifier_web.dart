import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/task.dart';
import '../../../core/models/task_activity.dart';
import 'task_providers.dart';

class TaskNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    return <Task>[];
  }

  Future<void> addTask(Task task) async {
    final current = [...(state.valueOrNull ?? const <Task>[])];
    state = AsyncData([...current, task]);
    _appendActivity(task.uuid, 'created', 'Task created');
    _pushNotification(task.uuid, 'upcoming', 'Task added', task.title);
  }

  Future<void> updateTask(Task task) async {
    final current = [...(state.valueOrNull ?? const <Task>[])];
    final index = current.indexWhere((item) => item.uuid == task.uuid);
    if (index < 0) return;
    current[index] = task..updatedAt = DateTime.now();
    state = AsyncData(current);
    _appendActivity(task.uuid, 'edited', 'Task updated');
  }

  Future<void> deleteTask(String uuid) async {
    final current = [...(state.valueOrNull ?? const <Task>[])];
    final updated = current.where((task) => task.uuid != uuid).toList();
    state = AsyncData(updated);
  }

  Future<void> moveTask(String uuid, String newStatus) async {
    final current = [...(state.valueOrNull ?? const <Task>[])];
    final index = current.indexWhere((item) => item.uuid == uuid);
    if (index < 0) return;
    final task = current[index];
    final updatedTask = task.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
    current[index] = updatedTask;
    state = AsyncData(current);

    _appendActivity(task.uuid, 'moved', 'Moved to $newStatus');
    if (newStatus == 'done') {
      _appendActivity(task.uuid, 'completed', 'Task marked complete');
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
    final current = [...(state.valueOrNull ?? const <Task>[])];
    final taskIndex = current.indexWhere((item) => item.uuid == taskId);
    if (taskIndex < 0) return;
    final task = current[taskIndex];
    final subtaskCompleted = [...task.subtaskCompleted];
    if (index < 0 || index >= subtaskCompleted.length) return;
    subtaskCompleted[index] = !subtaskCompleted[index];
    current[taskIndex] = task.copyWith(
      subtaskCompleted: subtaskCompleted,
      updatedAt: DateTime.now(),
    );
    state = AsyncData(current);
  }

  Future<void> markDone(String uuid) => moveTask(uuid, 'done');

  Future<void> updatePriority(String uuid, String priority) async {
    final current = [...(state.valueOrNull ?? const <Task>[])];
    final index = current.indexWhere((item) => item.uuid == uuid);
    if (index < 0) return;
    current[index] = current[index].copyWith(
      priority: priority,
      updatedAt: DateTime.now(),
    );
    state = AsyncData(current);
    _appendActivity(uuid, 'edited', 'Priority changed to $priority');
  }

  Future<void> updateDependencies(
    String taskId,
    List<String> dependencyIds,
  ) async {
    final current = [...(state.valueOrNull ?? const <Task>[])];
    final index = current.indexWhere((item) => item.uuid == taskId);
    if (index < 0) return;
    current[index] = current[index].copyWith(
      dependencyIds: dependencyIds,
      updatedAt: DateTime.now(),
    );
    state = AsyncData(current);
    _appendActivity(taskId, 'edited', 'Dependencies updated');
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

  void _appendActivity(String taskId, String action, String description) {
    final map = {...ref.read(taskActivitiesProvider)};
    final activities = [...(map[taskId] ?? const <TaskActivity>[])];
    final activity = TaskActivity()
      ..taskId = taskId
      ..action = action
      ..description = description
      ..timestamp = DateTime.now();
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
}
