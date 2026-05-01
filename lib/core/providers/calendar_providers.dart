import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../models/pomodoro_session.dart';
import '../models/study_event.dart';

// Selected date provider
class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void setDate(DateTime date) => state = date;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  () {
    return SelectedDateNotifier();
  },
);

// FutureProvider for Tasks
final tasksByDateProvider = FutureProvider.family<List<Task>, DateTime>((
  ref,
  date,
) async {
  // Since we don't have Isar instance setup yet in the code completely
  // we can use a provider to read the current state of tasks or return mock.
  // We'll return empty for now, but trigger rebuild if completion changes.
  ref.watch(taskCompletionProvider); // Watch completion changes to refresh

  // TODO: Replace with Isar fetch instance
  // final isar = Isar.getInstance()!;
  // final startOfDay = DateTime(date.year, date.month, date.day);
  // final endOfDay = startOfDay.add(const Duration(days: 1));
  // return isar.tasks.filter().dueDateBetween(startOfDay, endOfDay).findAll();
  return [];
});

class TaskCompletionNotifier extends Notifier<int> {
  @override
  int build() => 0; // Simple integer counter to trigger refreshes

  void toggleTask(Task task, bool completed) async {
    // Optimistic update for UI in current session
    task.isCompleted = completed;

    // TODO: Update in Isar database
    // final isar = Isar.getInstance()!;
    // await isar.writeTxn(() async {
    //   await isar.tasks.put(task);
    // });

    // Increment state to trigger listeners
    state++;
  }
}

final taskCompletionProvider = NotifierProvider<TaskCompletionNotifier, int>(
  () {
    return TaskCompletionNotifier();
  },
);

// FutureProvider for Pomodoro Sessions
final sessionsByDateProvider =
    FutureProvider.family<List<PomodoroSession>, DateTime>((ref, date) async {
      return [];
    });

// FutureProvider for Streak Days
final streakDaysProvider = FutureProvider<List<DateTime>>((ref) async {
  return []; // Return list of dates with activity
});

// FutureProvider for Study Events
final studyEventsProvider = FutureProvider<List<StudyEvent>>((ref) async {
  return [];
});
