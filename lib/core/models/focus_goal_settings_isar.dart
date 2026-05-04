import 'package:isar/isar.dart';

part 'focus_goal_settings_isar.g.dart';

@collection
class FocusGoalSettings {
  Id id = Isar.autoIncrement;

  late int focusDuration = 1500;
  late int shortBreakDuration = 300;
  late int longBreakDuration = 900;

  late int dailySessionGoal = 4;
  late int longBreakInterval = 4;

  late bool autoStartBreaks = false;
  late bool autoStartFocus = false;

  late double ambientVolume = 0.4;
  late double musicVolume = 0.8;

  String? lastAmbientSound;
  late bool wasTimerRunning = false;
  late int remainingSecondsOnKill = 1500;
  late String sessionTypeOnKill = 'focus';
  DateTime? killTimestamp;
}
