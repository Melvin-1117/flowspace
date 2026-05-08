import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/models/focus_goal_settings.dart';
import '../../../core/models/pomodoro_session.dart';
import '../../../core/providers/isar_provider.dart';
import 'ambient_sound_notifier.dart';
import 'music_player_notifier.dart';
import 'pomodoro_web_store.dart';
import 'timer_notifier.dart';

enum SessionType { focus, shortBreak, longBreak }

extension SessionTypeX on SessionType {
  String get label => switch (this) {
    SessionType.focus => 'Focus',
    SessionType.shortBreak => 'Short Break',
    SessionType.longBreak => 'Long Break',
  };

  String get key => switch (this) {
    SessionType.focus => 'focus',
    SessionType.shortBreak => 'shortbreak',
    SessionType.longBreak => 'longbreak',
  };

  Color get color => switch (this) {
    SessionType.focus => const Color(0xFF7C3AED),
    SessionType.shortBreak => const Color(0xFF06B6D4),
    SessionType.longBreak => const Color(0xFF10B981),
  };
}

extension SessionTypeFromName on SessionType {
  static SessionType fromName(String name) {
    switch (name) {
      case 'shortbreak':
        return SessionType.shortBreak;
      case 'longbreak':
        return SessionType.longBreak;
      default:
        return SessionType.focus;
    }
  }
}

class GoalProgress {
  const GoalProgress({
    required this.completedSessions,
    required this.goalSessions,
  });

  final int completedSessions;
  final int goalSessions;

  double get percent {
    if (goalSessions <= 0) return 0;
    return (completedSessions / goalSessions).clamp(0, 1).toDouble();
  }

  int get percentValue => (percent * 100).round();
  bool get isReached => completedSessions >= goalSessions;
}

class DayHeatmapData {
  const DayHeatmapData({
    required this.date,
    required this.completedSessions,
    required this.goalSessions,
    required this.goalMet,
    required this.totalFocusMinutes,
  });

  final DateTime date;
  final int completedSessions;
  final int goalSessions;
  final bool goalMet;
  final int totalFocusMinutes;
}

class CompletionOverlayState {
  const CompletionOverlayState({
    required this.sessionType,
    required this.actualDurationSeconds,
  });

  final SessionType sessionType;
  final int actualDurationSeconds;
}

final focusGoalSettingsProvider = FutureProvider<FocusGoalSettings>((
  ref,
) async {
  if (kIsWeb) {
    return PomodoroWebStore.instance.ensureSettings();
  }
  final isar = await ref.watch(isarProvider.future);
  final settings = await isar.focusGoalSettings.get(1);
  if (settings != null) return settings as FocusGoalSettings;

  final defaults = FocusGoalSettings()
    ..id = 1
    ..focusDuration = 1500
    ..shortBreakDuration = 300
    ..longBreakDuration = 900
    ..dailySessionGoal = 4
    ..longBreakInterval = 4
    ..autoStartBreaks = false
    ..autoStartFocus = false
    ..ambientVolume = 0.4
    ..musicVolume = 0.8
    ..lastAmbientSound = null
    ..wasTimerRunning = false
    ..remainingSecondsOnKill = 1500
    ..sessionTypeOnKill = 'focus'
    ..killTimestamp = null;

  await isar.writeTxn(() async {
    await isar.focusGoalSettings.put(defaults);
  });
  return defaults;
});

final timerNotifierProvider = NotifierProvider<TimerNotifier, TimerState>(
  TimerNotifier.new,
);

final sessionTypeProvider = Provider<SessionType>(
  (ref) => ref.watch(timerNotifierProvider).sessionType,
);

final timerRunningProvider = Provider<bool>(
  (ref) => ref.watch(timerNotifierProvider).isRunning,
);

final remainingSecondsProvider = Provider<int>(
  (ref) => ref.watch(timerNotifierProvider).remainingSeconds,
);

final formattedTimeProvider = Provider<String>((ref) {
  final seconds = ref.watch(remainingSecondsProvider);
  final minutes = seconds ~/ 60;
  final secs = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
});

final sessionCountProvider = Provider<int>(
  (ref) => ref.watch(timerNotifierProvider).completedFocusSessionsToday,
);

final allSessionsProvider = FutureProvider<List<PomodoroSession>>((ref) async {
  if (kIsWeb) {
    final sessions = [...PomodoroWebStore.instance.sessions];
    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    return sessions;
  }
  final isar = await ref.watch(isarProvider.future);
  final sessions =
      await isar.pomodoroSessions.where().findAll() as List<PomodoroSession>;
  sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
  return sessions;
});

final todaySessionsProvider = FutureProvider<List<PomodoroSession>>((
  ref,
) async {
  final now = DateTime.now();
  final dayStart = DateTime(now.year, now.month, now.day);
  final dayEnd = dayStart.add(const Duration(days: 1));
  final source = kIsWeb
      ? PomodoroWebStore.instance.sessions
      : await (await ref.watch(
              isarProvider.future,
            )).pomodoroSessions.where().findAll()
            as List<PomodoroSession>;
  final today = source
      .where(
        (s) => !s.startTime.isBefore(dayStart) && s.startTime.isBefore(dayEnd),
      )
      .toList();
  today.sort((a, b) => b.startTime.compareTo(a.startTime));
  return today;
});

final dailyGoalProvider = FutureProvider<GoalProgress>((ref) async {
  final sessions = await ref.watch(todaySessionsProvider.future);
  final settings = await ref.watch(focusGoalSettingsProvider.future);
  final completed = sessions
      .where((s) => s.sessionType == 'focus' && s.isCompleted)
      .length;
  return GoalProgress(
    completedSessions: completed,
    goalSessions: settings.dailySessionGoal,
  );
});

final weeklyHeatmapProvider = FutureProvider<List<DayHeatmapData>>((ref) async {
  final isar = kIsWeb ? null : await ref.watch(isarProvider.future);
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  final result = <DayHeatmapData>[];

  for (var i = 0; i < 7; i++) {
    final day = weekStart.add(Duration(days: i));
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final all = kIsWeb
        ? PomodoroWebStore.instance.sessions
        : await (isar as Isar).pomodoroSessions.where().findAll()
              as List<PomodoroSession>;
    final sessions = all
        .where(
          (s) =>
              !s.startTime.isBefore(dayStart) &&
              s.startTime.isBefore(dayEnd) &&
              s.isCompleted &&
              s.sessionType == 'focus',
        )
        .toList();
    final settings = kIsWeb
        ? PomodoroWebStore.instance.ensureSettings()
        : await (isar as Isar).focusGoalSettings.get(1) as FocusGoalSettings?;
    final goal = settings?.dailySessionGoal ?? 4;
    final completed = sessions.length;

    result.add(
      DayHeatmapData(
        date: day,
        completedSessions: completed,
        goalSessions: goal,
        goalMet: completed >= goal,
        totalFocusMinutes: sessions.fold(
          0,
          (sum, s) => sum + (s.actualDurationSeconds ~/ 60),
        ),
      ),
    );
  }
  return result;
});

final goalStreakProvider = FutureProvider<int>((ref) async {
  final isar = kIsWeb ? null : await ref.watch(isarProvider.future);
  var streak = 0;
  var day = DateTime.now();
  while (true) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final all = kIsWeb
        ? PomodoroWebStore.instance.sessions
        : await (isar as Isar).pomodoroSessions.where().findAll()
              as List<PomodoroSession>;
    final sessions = all
        .where(
          (s) =>
              !s.startTime.isBefore(dayStart) &&
              s.startTime.isBefore(dayEnd) &&
              s.isCompleted &&
              s.sessionType == 'focus',
        )
        .toList();
    final settings = kIsWeb
        ? PomodoroWebStore.instance.ensureSettings()
        : await (isar as Isar).focusGoalSettings.get(1) as FocusGoalSettings?;
    final goal = settings?.dailySessionGoal ?? 4;
    if (sessions.length >= goal) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }
  return streak;
});

final bestGoalStreakProvider = FutureProvider<int>((ref) async {
  final isar = kIsWeb ? null : await ref.watch(isarProvider.future);
  final settings = kIsWeb
      ? PomodoroWebStore.instance.ensureSettings()
      : await (isar as Isar).focusGoalSettings.get(1) as FocusGoalSettings?;
  final goal = settings?.dailySessionGoal ?? 4;

  var best = 0;
  var current = 0;
  for (var i = 365; i >= 0; i--) {
    final day = DateTime.now().subtract(Duration(days: i));
    final dayStart = DateTime(day.year, day.month, day.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final all = kIsWeb
        ? PomodoroWebStore.instance.sessions
        : await (isar as Isar).pomodoroSessions.where().findAll()
              as List<PomodoroSession>;
    final sessions = all
        .where(
          (s) =>
              !s.startTime.isBefore(dayStart) &&
              s.startTime.isBefore(dayEnd) &&
              s.isCompleted &&
              s.sessionType == 'focus',
        )
        .toList();
    if (sessions.length >= goal) {
      current++;
      if (current > best) best = current;
    } else {
      current = 0;
    }
  }
  return best;
});

Color heatmapCellColor(DayHeatmapData data) {
  if (data.completedSessions == 0) return const Color(0xFF0D0D0D);
  final ratio = data.completedSessions / data.goalSessions;
  if (ratio >= 1.0) return const Color(0xFF7C3AED);
  if (ratio >= 0.5) return const Color(0xFF4C1D95);
  return const Color(0xFF2D1B69);
}

class FocusGoalSettingsUpdater extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateSettings(FocusGoalSettings newSettings) async {
    if (kIsWeb) {
      PomodoroWebStore.instance.updateSettings(newSettings);
      ref.invalidate(focusGoalSettingsProvider);
      return;
    }
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.focusGoalSettings.put(newSettings);
    });
    ref.invalidate(focusGoalSettingsProvider);
    final isRunning = ref.read(timerRunningProvider);
    if (!isRunning) {
      await ref.read(timerNotifierProvider.notifier).applyNewDuration();
    }
  }
}

final focusGoalSettingsUpdaterProvider =
    AsyncNotifierProvider<FocusGoalSettingsUpdater, void>(
      FocusGoalSettingsUpdater.new,
    );

final musicPlayerProvider =
    StateNotifierProvider<MusicPlayerNotifier, MusicState>(
      (ref) => MusicPlayerNotifier(),
    );

final ambientSoundProvider =
    StateNotifierProvider<AmbientSoundNotifier, AmbientState>(
      (ref) => AmbientSoundNotifier(),
    );
