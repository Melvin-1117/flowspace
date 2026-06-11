import 'package:isar/isar.dart';

part 'daily_dev_log_isar.g.dart';

@collection
class DailyDevLog {
  Id id = Isar.autoIncrement;

  late String uuid;
  late DateTime date;
  int totalCodingMinutes = 0;
  List<String> languagesUsed = [];
  List<String> projectsWorked = [];
  int tasksCompleted = 0;
  int pomodoroSessions = 0;
  String? highlight; // "Shipped auth feature"
  int energyLevel = 3; // 1–5 (user rates their day)
}
