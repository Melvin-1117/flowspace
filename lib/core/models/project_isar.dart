import 'package:isar/isar.dart';
part 'project_isar.g.dart';

@collection
class Project {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String uuid;
  late String name;
  late DateTime createdAt;
  late List<String> memberIds;
}
