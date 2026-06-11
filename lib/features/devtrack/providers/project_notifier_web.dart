import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/coding_session.dart';
import '../models/dev_project.dart';

class ProjectNotifier extends AsyncNotifier<List<DevProject>> {
  @override
  Future<List<DevProject>> build() async => [];

  Future<void> addProject(DevProject p) async {}
  Future<void> updateProject(DevProject p) async {}
  Future<void> deleteProject(String uuid) async {}
  Future<void> updateProgress(String uuid, int percent) async {}
  Future<void> logCodingSession(CodingSession s) async {}
}

final projectNotifierProvider =
    AsyncNotifierProvider<ProjectNotifier, List<DevProject>>(
  ProjectNotifier.new,
);
