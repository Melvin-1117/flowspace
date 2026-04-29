import 'package:isar/isar.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  late String title;
  late String priority; // 'urgent', 'normal', 'low'
  late String tag; // 'assignment', 'exam', 'project'
  late DateTime dueDate;
  late bool isCompleted;
  late bool isRecurring;
}
