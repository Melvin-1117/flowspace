import 'subject_module.dart';

class Subject {
  Subject({
    this.id = 0,
    required this.uuid,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.totalModules,
    required this.completedModules,
    required this.examDate,
    required this.weeklyGoalHours,
    required this.createdAt,
    this.modules = const <SubjectModule>[],
  });

  int id;
  String uuid;
  String name;
  String iconName;
  String colorHex;
  int totalModules;
  int completedModules;
  DateTime? examDate;
  int weeklyGoalHours;
  DateTime createdAt;
  List<SubjectModule> modules;

  double get completionPercent =>
      totalModules == 0 ? 0 : completedModules / totalModules;
}
