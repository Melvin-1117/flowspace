class SkillEntry {
  int id = 0;

  late String uuid;
  late String skillName;
  late String category;
  int proficiencyLevel = 1;
  int hoursInvested = 0;
  late DateTime firstLearnedAt;
  late DateTime lastPracticedAt;
  List<String> linkedProjectIds = [];
  String notes = '';
}
