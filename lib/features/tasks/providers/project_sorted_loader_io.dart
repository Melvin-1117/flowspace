import 'package:isar/isar.dart';

import '../../../core/models/project_isar.dart';

Future<List<Project>> loadSortedProjects(Isar isar) {
  return isar
      .collection<Project>()
      .where()
      .sortByCreatedAt()
      .findAll();
}
