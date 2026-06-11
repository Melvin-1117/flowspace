import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/isar_provider.dart';
import '../models/coding_session_isar.dart';
import '../models/dev_project_isar.dart';
import 'devtrack_providers.dart';

class ProjectNotifier extends AsyncNotifier<List<DevProject>> {
  @override
  Future<List<DevProject>> build() async {
    final isar = await ref.read(isarProvider.future);
    return isar
        .collection<DevProject>()
        .where()
        .sortByLastActiveAtDesc()
        .findAll();
  }

  Future<void> addProject(DevProject p) async {
    final isar = await ref.read(isarProvider.future);
    p.uuid = const Uuid().v4();
    await isar.writeTxn(() => isar.collection<DevProject>().put(p));
    ref.invalidate(allProjectsProvider);
    ref.invalidate(activeProjectsProvider);
    ref.invalidateSelf();
  }

  Future<void> updateProject(DevProject p) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() => isar.collection<DevProject>().put(p));
    ref.invalidate(allProjectsProvider);
    ref.invalidate(activeProjectsProvider);
    ref.invalidateSelf();
  }

  Future<void> deleteProject(String uuid) async {
    final isar = await ref.read(isarProvider.future);
    final project = await isar
        .collection<DevProject>()
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    if (project != null) {
      await isar.writeTxn(() => isar.collection<DevProject>().delete(project.id));
    }
    ref.invalidate(allProjectsProvider);
    ref.invalidate(activeProjectsProvider);
    ref.invalidateSelf();
  }

  Future<void> updateProgress(String uuid, int percent) async {
    final isar = await ref.read(isarProvider.future);
    final project = await isar
        .collection<DevProject>()
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    if (project != null) {
      project.completionPercent = percent.clamp(0, 100);
      project.lastActiveAt = DateTime.now();
      if (percent >= 100) {
        project.status = 'completed';
        project.completedAt = DateTime.now();
      }
      await isar.writeTxn(() => isar.collection<DevProject>().put(project));
    }
    ref.invalidate(allProjectsProvider);
    ref.invalidate(activeProjectsProvider);
    ref.invalidateSelf();
  }

  Future<void> logCodingSession(CodingSession s) async {
    final isar = await ref.read(isarProvider.future);
    s.uuid = const Uuid().v4();
    await isar.writeTxn(() => isar.collection<CodingSession>().put(s));

    // Update project total coding minutes
    if (s.projectId.isNotEmpty) {
      final project = await isar
          .collection<DevProject>()
          .filter()
          .uuidEqualTo(s.projectId)
          .findFirst();
      if (project != null) {
        project.totalCodingMinutes += s.durationMinutes;
        project.lastActiveAt = DateTime.now();
        await isar.writeTxn(() => isar.collection<DevProject>().put(project));
      }
    }

    ref.invalidate(allCodingSessionsProvider);
    ref.invalidate(todayCodingSessionsProvider);
    ref.invalidate(activityHeatmapProvider);
    ref.invalidate(devtrackLanguageDistributionProvider);
    ref.invalidate(codingStreakProvider);
    ref.invalidate(totalCodingHoursProvider);
    ref.invalidate(allProjectsProvider);
    ref.invalidate(activeProjectsProvider);
    ref.invalidateSelf();
  }
}

final projectNotifierProvider =
    AsyncNotifierProvider<ProjectNotifier, List<DevProject>>(
  ProjectNotifier.new,
);
