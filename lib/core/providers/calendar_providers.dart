import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/tasks/providers/task_providers.dart';
import '../models/task.dart';

export 'calendar_sessions_providers.dart';

final selectedDateProvider =
    NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  void setDate(DateTime d) {
    state = DateTime(d.year, d.month, d.day);
  }
}

final tasksByDateProvider =
    Provider.family<AsyncValue<List<Task>>, DateTime>((ref, day) {
  final normalized = DateTime(day.year, day.month, day.day);
  final tasksAsync = ref.watch(taskNotifierProvider);
  return tasksAsync.when(
    data: (tasks) => AsyncData(
      tasks.where((t) {
        final d = t.dueDate;
        if (d == null) return false;
        return _isSameCalendarDay(d, normalized);
      }).toList(),
    ),
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
  );
});

final taskCompletionProvider =
    NotifierProvider<TaskCompletionNotifier, int>(TaskCompletionNotifier.new);

class TaskCompletionNotifier extends Notifier<int> {
  @override
  int build() => 0;

  Future<void> toggleTask(Task task, bool completed) async {
    await ref.read(taskNotifierProvider.notifier).moveTask(
          task.uuid,
          completed ? 'done' : 'todo',
        );
    state++;
  }
}

bool _isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
