class FocusLockSession {
  int id = 0;

  late String uuid;
  late int durationMinutes;
  late int strikes;
  late bool isCompleted;
  late bool isVoid;
  late DateTime startedAt;
  DateTime? completedAt;
  late int focusScore;
}
