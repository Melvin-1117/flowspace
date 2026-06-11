class CodingSession {
  int id = 0;

  late String uuid;
  late String projectId;
  late String language;
  late DateTime startTime;
  late DateTime endTime;
  late int durationMinutes;
  late String sessionType;
  String notes = '';
  bool linkedToPomodoro = false;
  String? linkedPomodoroId;
}
