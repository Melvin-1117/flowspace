import 'package:isar/isar.dart';
part 'task_activity_isar.g.dart';

@collection
class TaskActivity {
  Id id = Isar.autoIncrement;
  @Index()
  late String taskId;
  late String action; // 'created', 'moved', 'edited', 'completed'
  late String description;
  late DateTime timestamp;
}
