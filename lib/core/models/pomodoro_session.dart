import 'package:isar/isar.dart';

@collection
class PomodoroSession {
  Id id = Isar.autoIncrement;
  late String linkedTaskId; // ID of the task being focused on
  late String linkedTaskTitle; // Title shown on the card
  late DateTime startTime; // When session started
  late int totalDurationSeconds; // e.g. 1500 for 25 minutes
  late int remainingSeconds; // Countdown value, updated live
  late bool isRunning; // true = active, false = paused
  late bool isCompleted; // true = session finished
  late int completedSubtasks; // e.g. 3
  late int totalSubtasks; // e.g. 5
}
