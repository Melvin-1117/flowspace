import 'package:isar/isar.dart';

part 'skill_entry_isar.g.dart';

@collection
class SkillEntry {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String skillName; // 'Flutter', 'System Design'
  late String category; // 'language', 'framework', 'concept', 'tool'
  int proficiencyLevel = 1; // 1–5
  int hoursInvested = 0; // total hours practiced
  late DateTime firstLearnedAt;
  late DateTime lastPracticedAt;
  List<String> linkedProjectIds = [];
  String notes = '';
}
