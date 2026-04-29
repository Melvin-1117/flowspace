import 'package:isar/isar.dart';

@collection
class PomodoroSession {
  Id id = Isar.autoIncrement;
  late DateTime date;
  late int durationMinutes;
  late bool isCompleted;
}
