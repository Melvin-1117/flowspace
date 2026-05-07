class FocusBlock {
  FocusBlock({
    this.id = 0,
    required this.uuid,
    required this.title,
    required this.linkedSubjectId,
    required this.linkedTaskId,
    required this.sessionType,
    required this.scheduledTime,
    required this.durationMinutes,
    required this.isCompleted,
    required this.completedAt,
    required this.repeatRule,
    required this.reminderEnabled,
    required this.reminderMinutesBefore,
  });

  int id;
  String uuid;
  String title;
  String? linkedSubjectId;
  String? linkedTaskId;
  String sessionType;
  DateTime scheduledTime;
  int durationMinutes;
  bool isCompleted;
  DateTime? completedAt;
  String repeatRule;
  bool reminderEnabled;
  int reminderMinutesBefore;
}
