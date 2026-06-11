import 'package:isar/isar.dart';

part 'dev_project_isar.g.dart';

@collection
class DevProject {
  Id id = Isar.autoIncrement;

  late String uuid;
  late String name; // "FlowSpace App"
  String description = '';
  late String status; // 'active', 'paused', 'completed', 'planned'
  late String primaryLanguage;
  List<String> techStack = []; // ['Flutter', 'Dart', 'Isar']
  int completionPercent = 0; // 0–100
  late DateTime startedAt;
  DateTime? completedAt;
  late DateTime lastActiveAt;
  List<String> linkedTaskIds = [];
  int totalCodingMinutes = 0; // auto-computed
  String colorHex = '#006EE6'; // project accent color
  String iconName = 'code'; // project icon
}
