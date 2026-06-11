class DevProject {
  int id = 0;

  late String uuid;
  late String name;
  String description = '';
  late String status;
  late String primaryLanguage;
  List<String> techStack = [];
  int completionPercent = 0;
  late DateTime startedAt;
  DateTime? completedAt;
  late DateTime lastActiveAt;
  List<String> linkedTaskIds = [];
  int totalCodingMinutes = 0;
  String colorHex = '#006EE6';
  String iconName = 'code';
}
