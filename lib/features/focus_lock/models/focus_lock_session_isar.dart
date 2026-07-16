import 'package:isar/isar.dart';

part 'focus_lock_session_isar.g.dart';

@collection
class FocusLockSession {
  Id id = Isar.autoIncrement;

  late String uuid;
  late int durationMinutes;
  late int strikes;
  late bool isCompleted;
  late bool isVoid;
  late DateTime startedAt;
  DateTime? completedAt;
  late int focusScore;
}
