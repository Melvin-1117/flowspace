import 'package:isar/isar.dart';

part 'coding_session_isar.g.dart';

@collection
class CodingSession {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String projectId; // linked DevProject uuid
  late String language; // 'Dart', 'Python' etc
  late DateTime startTime;
  late DateTime endTime;
  late int durationMinutes;
  late String sessionType; // 'feature', 'bugfix', 'learning', 'review'
  String notes = ''; // what was worked on
  bool linkedToPomodoro = false;
  String? linkedPomodoroId;
}
