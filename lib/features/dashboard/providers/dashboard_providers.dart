/// Dashboard-specific derived providers.
///
/// These are thin selectors/combinators that read from existing feature
/// providers. No business logic lives here — the dashboard never owns data.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../tasks/providers/task_providers.dart';
import '../../pomodoro/providers/pomodoro_providers.dart';
import '../../../core/providers/calendar_providers.dart';

// ── Tasks Due Today ─────────────────────────────────────────────────────────
final dashboardTasksDueTodayProvider = Provider<int>((ref) {
  final tasksAsync = ref.watch(allTasksProvider);
  final tasks = tasksAsync.valueOrNull ?? <dynamic>[];
  final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return tasks.where((t) {
    final d = t.dueDate;
    if (d == null) return false;
    return DateFormat('yyyy-MM-dd').format(d) == todayStr &&
        t.status != 'done';
  }).length;
});

// ── Focus Streak (number of consecutive days) ───────────────────────────────
final dashboardStreakProvider = Provider<int>((ref) {
  final streakAsync = ref.watch(streakDaysProvider);
  return streakAsync.valueOrNull?.length ?? 0;
});

// ── Completed Focus Sessions Today ──────────────────────────────────────────
final dashboardSessionsTodayProvider = Provider<int>((ref) {
  final sessionsAsync = ref.watch(todaySessionsProvider);
  final sessions = sessionsAsync.valueOrNull ?? <dynamic>[];
  return sessions
      .where((s) => s.isCompleted && s.sessionType == 'focus')
      .length;
});

// ── Is a session currently active? ──────────────────────────────────────────
final dashboardIsSessionActiveProvider = Provider<bool>((ref) {
  final timer = ref.watch(timerNotifierProvider);
  return timer.isRunning;
});

// ── Is everything empty? (new user check) ───────────────────────────────────
final dashboardIsNewUserProvider = Provider<bool>((ref) {
  final tasks = ref.watch(allTasksProvider).valueOrNull ?? [];
  final sessions = ref.watch(todaySessionsProvider).valueOrNull ?? [];
  final streak = ref.watch(streakDaysProvider).valueOrNull ?? [];
  return tasks.isEmpty && sessions.isEmpty && streak.isEmpty;
});
