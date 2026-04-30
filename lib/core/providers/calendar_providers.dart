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
  // TODO: Replace with Isar fetch instance
  // final isar = Isar.getInstance()!;
  // final startOfDay = DateTime(date.year, date.month, date.day);
  // final endOfDay = startOfDay.add(const Duration(days: 1));
  // return isar.tasks.filter().dueDateBetween(startOfDay, endOfDay).findAll();
  return []; // Return empty for now to avoid crashing until Isar is initialized
});

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
