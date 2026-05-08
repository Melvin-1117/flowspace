import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../models/pomodoro_session_isar.dart';
import 'isar_provider.dart';

final sessionsByDateProvider =
    FutureProvider.family<List<PomodoroSession>, DateTime>((ref, day) async {
      final isar = await ref.watch(isarProvider.future);
      final normalized = DateTime(day.year, day.month, day.day);
      final all =
          await isar.pomodoroSessions.where().findAll()
              as List<PomodoroSession>;
      return all
          .where((s) => _isSameCalendarDay(s.startTime, normalized))
          .toList();
    });

final streakDaysProvider = FutureProvider<List<DateTime>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  final sessions =
      await isar.pomodoroSessions.where().findAll() as List<PomodoroSession>;
  final daysWithActivity = <DateTime>{};
  for (final s in sessions) {
    if (!s.isCompleted) continue;
    final t = s.startTime;
    daysWithActivity.add(DateTime(t.year, t.month, t.day));
  }
  final now = DateTime.now();
  var d = DateTime(now.year, now.month, now.day);
  final streak = <DateTime>[];
  while (daysWithActivity.contains(d)) {
    streak.add(d);
    d = d.subtract(const Duration(days: 1));
  }
  return streak;
});

bool _isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
