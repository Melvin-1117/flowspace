class PomodoroSession {
  int id = 0;
  late String uuid;
  late String sessionType;
  String? linkedTaskId;
  String? linkedTaskTitle;
  late DateTime startTime;
  DateTime? endTime;
  late int plannedDurationSeconds;
  late int actualDurationSeconds;
  late bool isCompleted;
  late bool isAbandoned;
}
