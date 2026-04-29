import 'package:isar/isar.dart';

@collection
class StudyEvent {
  Id id = Isar.autoIncrement;
  late String title;
  late String type; // 'exam', 'submission', 'revision'
  late DateTime eventDate;
  late String subject;
}
