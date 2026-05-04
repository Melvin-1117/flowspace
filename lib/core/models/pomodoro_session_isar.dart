import 'package:isar/isar.dart';
part 'pomodoro_session_isar.g.dart';

@collection
class PomodoroSession {
  Id id = Isar.autoIncrement;

  late String uuid;

  late String sessionType;

  String? linkedTaskId;
  String? linkedTaskTitle;

  late DateTime startTime;
  DateTime? endTime;
  late int plannedDurationSeconds;
  late int actualDurationSeconds;

  late bool isCompleted;
  late bool isAbandoned;
}
