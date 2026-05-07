class Milestone {
  Milestone({
    this.id = 0,
    required this.uuid,
    required this.title,
    required this.description,
    required this.linkedSubjectId,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.completedAt,
    required this.checklistItems,
    required this.checklistCompleted,
  });

  int id;
  String uuid;
  String title;
  String description;
  String? linkedSubjectId;
  DateTime dueDate;
  String priority;
  bool isCompleted;
  DateTime? completedAt;
  List<String> checklistItems;
  List<bool> checklistCompleted;

  bool get isOverdue => !isCompleted && dueDate.isBefore(DateTime.now());
}
