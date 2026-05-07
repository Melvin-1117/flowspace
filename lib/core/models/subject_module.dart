class SubjectModule {
  SubjectModule({
    this.id = 0,
    required this.uuid,
    required this.subjectId,
    required this.name,
    required this.moduleNumber,
    required this.isCompleted,
    required this.completedAt,
    required this.linkedNoteIds,
  });

  int id;
  String uuid;
  String subjectId;
  String name;
  int moduleNumber;
  bool isCompleted;
  DateTime? completedAt;
  List<String> linkedNoteIds;
}
