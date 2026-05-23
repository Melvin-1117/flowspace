import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/providers/isar_provider.dart';
import '../../../core/models/project.dart';
import '../../../core/models/task.dart';
import '../../../core/models/task_activity.dart';
import 'project_sorted_loader.dart';
import 'task_notifier.dart';

enum ViewMode { kanban, list }

enum DueDateFilter { all, today, week, overdue }

class TaskFilters {
  const TaskFilters({
    this.priorities = const {},
    this.tags = const {},
    this.statuses = const {},
    this.dueDate = DueDateFilter.all,
  });

  final Set<String> priorities;
  final Set<String> tags;
  final Set<String> statuses;
  final DueDateFilter dueDate;

  bool get isEmpty =>
      priorities.isEmpty &&
      tags.isEmpty &&
      statuses.isEmpty &&
      dueDate == DueDateFilter.all;

  int get activeCount {
    var count = 0;
    if (priorities.isNotEmpty) count++;
    if (tags.isNotEmpty) count++;
    if (statuses.isNotEmpty) count++;
    if (dueDate != DueDateFilter.all) count++;
    return count;
  }

  TaskFilters copyWith({
    Set<String>? priorities,
    Set<String>? tags,
    Set<String>? statuses,
    DueDateFilter? dueDate,
  }) {
    return TaskFilters(
      priorities: priorities ?? this.priorities,
      tags: tags ?? this.tags,
      statuses: statuses ?? this.statuses,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}

class AppUserProfile {
  const AppUserProfile({
    required this.name,
    required this.email,
    required this.avatarInitials,
    required this.streakDays,
  });

  final String name;
  final String email;
  final String avatarInitials;
  final int streakDays;
}

class AppNotification {
  const AppNotification({
    required this.id,
    required this.taskId,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.unread = true,
  });

  final String id;
  final String taskId;
  final String type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool unread;

  AppNotification copyWith({bool? unread}) {
    return AppNotification(
      id: id,
      taskId: taskId,
      type: type,
      title: title,
      subtitle: subtitle,
      timestamp: timestamp,
      unread: unread ?? this.unread,
    );
  }
}

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.initials,
    required this.role,
  });

  final String id;
  final String name;
  final String initials;
  final String role;
}

final taskNotifierProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
);

// All tasks provider
final allTasksProvider = FutureProvider<List<Task>>((ref) async {
  return ref.watch(taskNotifierProvider.future);
});

// Tasks by status
final tasksByStatusProvider = FutureProvider.family<List<Task>, String>((
  ref,
  status,
) async {
  final all = await ref.watch(allTasksProvider.future);
  return all.where((task) => task.status == status).toList();
});

// Active filters provider
final activeFiltersProvider = StateProvider<TaskFilters>(
  (ref) => const TaskFilters(),
);

// Filtered tasks provider
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasksState = ref.watch(taskNotifierProvider);
  final filters = ref.watch(activeFiltersProvider);
  final allTasks = tasksState.valueOrNull ?? <Task>[];

  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final endOfWeek = startOfToday.add(const Duration(days: 7));

  return allTasks.where((task) {
    if (filters.priorities.isNotEmpty &&
        !filters.priorities.contains(task.priority)) {
      return false;
    }
    if (filters.tags.isNotEmpty && !filters.tags.contains(task.tag)) {
      return false;
    }
    if (filters.statuses.isNotEmpty &&
        !filters.statuses.contains(task.status)) {
      return false;
    }
    final dueDate = task.dueDate;
    switch (filters.dueDate) {
      case DueDateFilter.all:
        break;
      case DueDateFilter.today:
        if (dueDate == null ||
            dueDate.isBefore(startOfToday) ||
            dueDate.isAfter(startOfToday.add(const Duration(days: 1)))) {
          return false;
        }
        break;
      case DueDateFilter.week:
        if (dueDate == null ||
            dueDate.isBefore(startOfToday) ||
            dueDate.isAfter(endOfWeek)) {
          return false;
        }
        break;
      case DueDateFilter.overdue:
        if (dueDate == null ||
            !dueDate.isBefore(startOfToday) ||
            task.status == 'done') {
          return false;
        }
        break;
    }
    return true;
  }).toList();
});

// Project progress provider
final projectProgressProvider = Provider<double>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  if (tasks.isEmpty) return 0;
  final completedTasks = tasks.where((task) => task.status == 'done').length;
  return completedTasks / tasks.length;
});

// View mode provider
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.kanban);

// Selected tasks provider (multi-select mode)
final selectedTasksProvider = StateProvider<List<String>>((ref) => []);

final taskActivitiesProvider = StateProvider<Map<String, List<TaskActivity>>>(
  (ref) => {},
);

final projectProvider = AsyncNotifierProvider<ProjectNotifier, Project>(
  ProjectNotifier.new,
);

final teamMembersProvider = StateProvider<List<TeamMember>>((ref) {
  return const [
    TeamMember(id: 'me', name: 'You', initials: 'YU', role: 'Owner'),
  ];
});

final currentUserProvider = Provider<AppUserProfile>((ref) {
  final name = ref.watch(displayNameProvider);
  final username = ref.watch(usernameProvider);
  return AppUserProfile(
    name: name,
    email: username.isEmpty ? '' : '@$username',
    avatarInitials: _initialsFrom(name.isNotEmpty ? name : username),
    streakDays: 14,
  );
});

String _initialsFrom(String value) {
  if (value.trim().isEmpty) return '';
  final parts = value.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
}

final notificationsProvider = StateProvider<List<AppNotification>>((ref) => []);

final syncOnlineProvider = StateProvider<bool>((ref) => true);

class ProjectNotifier extends AsyncNotifier<Project> {
  @override
  Future<Project> build() async {
    if (kIsWeb) {
      return Project()
        ..uuid = const Uuid().v4()
        ..name = 'Project Sprint: Nebula'
        ..createdAt = DateTime.now()
        ..memberIds = ['me'];
    }

    final isar = await ref.watch(isarProvider.future);
    final projects = await loadSortedProjects(isar);
    if (projects.isNotEmpty) {
      return projects.first;
    }

    final project = Project()
      ..uuid = const Uuid().v4()
      ..name = 'Project Sprint: Nebula'
      ..createdAt = DateTime.now()
      ..memberIds = ['me'];
    await isar.writeTxn(() async {
      await isar.collection<Project>().put(project);
    });
    return project;
  }

  Future<void> rename(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current..name = trimmed;
    if (!kIsWeb) {
      final isar = await ref.read(isarProvider.future);
      await isar.writeTxn(() async {
        await isar.collection<Project>().put(updated);
      });
    }
    state = AsyncData(updated);
  }
}
