class FocusGoalSettings {
  int id = 0;

  int focusDuration = 1500;
  int shortBreakDuration = 300;
  int longBreakDuration = 900;

  int dailySessionGoal = 4;
  int longBreakInterval = 4;

  bool autoStartBreaks = false;
  bool autoStartFocus = false;

  double ambientVolume = 0.4;
  double musicVolume = 0.8;

  String? lastAmbientSound;
  bool wasTimerRunning = false;
  int remainingSecondsOnKill = 1500;
  String sessionTypeOnKill = 'focus';
  DateTime? killTimestamp;
}
