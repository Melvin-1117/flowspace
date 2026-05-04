import 'package:uuid/uuid.dart';

import '../../../core/models/focus_goal_settings.dart';
import '../../../core/models/pomodoro_session.dart';

class PomodoroWebStore {
  PomodoroWebStore._();

  static final PomodoroWebStore instance = PomodoroWebStore._();

  FocusGoalSettings settings = _defaultSettings();
  final List<PomodoroSession> sessions = [];

  FocusGoalSettings ensureSettings() {
    settings.id = 1;
    return settings;
  }

  void updateSettings(FocusGoalSettings updated) {
    settings = updated;
    settings.id = 1;
  }

  PomodoroSession upsertSession(PomodoroSession session) {
    if (session.uuid.trim().isEmpty) {
      session.uuid = const Uuid().v4();
    }
    final index = sessions.indexWhere((s) => s.uuid == session.uuid);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }
    return session;
  }

  static FocusGoalSettings _defaultSettings() {
    return FocusGoalSettings()
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
  }
}
