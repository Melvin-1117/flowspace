import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/models/pomodoro_session_isar.dart';
import '../../../core/providers/isar_provider.dart';
import '../models/coding_session_isar.dart';
import '../models/day_activity_data.dart';
import '../models/dev_project_isar.dart';
import '../models/skill_entry_isar.dart';

// ── All projects ────────────────────────────────────────────────────────────
final allProjectsProvider = FutureProvider<List<DevProject>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar
      .collection<DevProject>()
      .where()
      .sortByLastActiveAtDesc()
      .findAll();
});

// ── Active projects only ────────────────────────────────────────────────────
final activeProjectsProvider = FutureProvider<List<DevProject>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar
      .collection<DevProject>()
      .filter()
      .statusEqualTo('active')
      .findAll();
});

// ── All coding sessions ─────────────────────────────────────────────────────
final allCodingSessionsProvider = FutureProvider<List<CodingSession>>((
  ref,
) async {
  final isar = await ref.watch(isarProvider.future);
  return isar
      .collection<CodingSession>()
      .where()
      .sortByStartTimeDesc()
      .findAll();
});

// ── Today's coding sessions ─────────────────────────────────────────────────
final todayCodingSessionsProvider = FutureProvider<List<CodingSession>>((
  ref,
) async {
  final isar = await ref.watch(isarProvider.future);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return isar
      .collection<CodingSession>()
      .filter()
      .startTimeBetween(start, end)
      .findAll();
});

// ── Language distribution from coding sessions ──────────────────────────────
final devtrackLanguageDistributionProvider =
    FutureProvider<Map<String, double>>((ref) async {
      final sessions = await ref.watch(allCodingSessionsProvider.future);
      final Map<String, int> totals = {};
      for (final s in sessions) {
        totals[s.language] = (totals[s.language] ?? 0) + s.durationMinutes;
      }
      final total = totals.values.fold(0, (a, b) => a + b);
      if (total == 0) return {};
      return totals.map((k, v) => MapEntry(k, v / total * 100));
    });

// ── 90-day activity heatmap ─────────────────────────────────────────────────
final activityHeatmapProvider = FutureProvider<List<DayActivityData>>((
  ref,
) async {
  final isar = await ref.watch(isarProvider.future);
  final now = DateTime.now();
  final List<DayActivityData> result = [];
  for (int i = 89; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final sessions = await isar
        .collection<CodingSession>()
        .filter()
        .startTimeBetween(start, end)
        .findAll();
    final pomodoros = await isar
        .collection<PomodoroSession>()
        .filter()
        .startTimeBetween(start, end)
        .isCompletedEqualTo(true)
        .findAll();
    result.add(
      DayActivityData(
        date: day,
        codingMinutes: sessions.fold(0, (s, e) => s + e.durationMinutes),
        pomodoroCount: pomodoros.length,
        sessionCount: sessions.length,
      ),
    );
  }
  return result;
});

// ── All skills ──────────────────────────────────────────────────────────────
final allSkillsProvider = FutureProvider<List<SkillEntry>>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return isar
      .collection<SkillEntry>()
      .where()
      .sortByHoursInvestedDesc()
      .findAll();
});

// ── Coding streak (consecutive days with activity) ──────────────────────────
final codingStreakProvider = FutureProvider<int>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  int streak = 0;
  DateTime day = DateTime.now();
  while (true) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final sessions = await isar
        .collection<CodingSession>()
        .filter()
        .startTimeBetween(start, end)
        .findAll();
    if (sessions.isEmpty) break;
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
});

// ── Total coding hours all time ─────────────────────────────────────────────
final totalCodingHoursProvider = FutureProvider<double>((ref) async {
  final sessions = await ref.watch(allCodingSessionsProvider.future);
  final total = sessions.fold(0, (sum, s) => sum + s.durationMinutes);
  return total / 60;
});
