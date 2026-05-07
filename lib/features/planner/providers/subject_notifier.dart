import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/milestone.dart';
import '../../../core/models/subject.dart';
import '../../../core/models/task.dart';
import '../../../core/providers/isar_provider.dart';
import '../../pomodoro/providers/pomodoro_web_store.dart';
import 'planner_providers.dart';
import 'planner_storage.dart';

class SubjectNotifier extends AsyncNotifier<List<Subject>> {
  @override
  Future<List<Subject>> build() async {
    return _load();
  }

  // Creates and persists a planner subject.
  Future<void> addSubject(Subject subject) async {
    if (kIsWeb) return;
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await (isar as dynamic).tasks.put(PlannerStorage.fromSubject(subject));
    });
    state = AsyncData(await _load());
    ref.invalidate(allSubjectsProvider);
    ref.invalidate(semesterHealthProvider);
  }

  // Updates planner subject fields and module progress.
  Future<void> updateSubject(Subject subject) async {
    if (kIsWeb) return;
    final isar = await ref.read(isarProvider.future);
    final existing = await _taskByUuid(isar, subject.uuid);
    await isar.writeTxn(() async {
      await (isar as dynamic).tasks.put(
        PlannerStorage.fromSubject(subject, existing: existing),
      );
    });
    state = AsyncData(await _load());
    ref.invalidate(allSubjectsProvider);
    ref.invalidate(semesterHealthProvider);
  }

  // Deletes subject and linked planner records.
  Future<void> deleteSubject(String uuid) async {
    if (kIsWeb) return;
    final isar = await ref.read(isarProvider.future);
    final all = await (isar as dynamic).tasks.where().findAll() as List<Task>;
    final toDelete = all
        .where((task) {
          if (task.tag == plannerSubjectTag && task.uuid == uuid) return true;
          if (task.tag == plannerMilestoneTag &&
              task.description.contains(uuid)) {
            return true;
          }
          if (task.tag == plannerFocusBlockTag &&
              task.description.contains(uuid)) {
            return true;
          }
          return false;
        })
        .map((task) => task.id);
    await isar.writeTxn(() async {
      for (final id in toDelete) {
        await (isar as dynamic).tasks.delete(id);
      }
    });
    state = AsyncData(await _load());
    ref.invalidate(allSubjectsProvider);
    ref.invalidate(allMilestonesProvider);
    ref.invalidate(todayFocusBlocksProvider);
    ref.invalidate(semesterHealthProvider);
  }

  // Marks the next unfinished module completed.
  Future<void> incrementModule(String uuid) async {
    final current = state.valueOrNull ?? <Subject>[];
    final index = current.indexWhere((s) => s.uuid == uuid);
    if (index < 0) return;
    final subject = current[index];
    final modules = [...subject.modules];
    final next = modules.indexWhere((m) => !m.isCompleted);
    if (next >= 0) {
      modules[next]
        ..isCompleted = true
        ..completedAt = DateTime.now();
    }
    final updated = Subject(
      id: subject.id,
      uuid: subject.uuid,
      name: subject.name,
      iconName: subject.iconName,
      colorHex: subject.colorHex,
      totalModules: subject.totalModules,
      completedModules: modules.where((m) => m.isCompleted).length,
      examDate: subject.examDate,
      weeklyGoalHours: subject.weeklyGoalHours,
      createdAt: subject.createdAt,
      modules: modules,
    );
    await updateSubject(updated);

    if (updated.completedModules >= updated.totalModules &&
        updated.examDate != null) {
      final milestone = Milestone(
        uuid: 'exam-${updated.uuid}',
        title: '${updated.name} Exam',
        description: '${updated.name} exam milestone',
        linkedSubjectId: updated.uuid,
        dueDate: updated.examDate!,
        priority: 'upcoming',
        isCompleted: true,
        completedAt: DateTime.now(),
        checklistItems: const <String>[],
        checklistCompleted: const <bool>[],
      );
      await ref
          .read(milestoneNotifierProvider.notifier)
          .addMilestone(milestone);
      await ref
          .read(milestoneNotifierProvider.notifier)
          .completeMilestone(milestone.uuid);
    }
  }

  Future<List<Subject>> _load() async {
    if (kIsWeb) return const <Subject>[];
    final isar = await ref.read(isarProvider.future);
    final tasks = await (isar as dynamic).tasks.where().findAll() as List<Task>;
    final subjects =
        tasks
            .where((task) => task.tag == plannerSubjectTag)
            .map(PlannerStorage.toSubject)
            .toList()
          ..sort((a, b) {
            final aDone = a.completedModules >= a.totalModules;
            final bDone = b.completedModules >= b.totalModules;
            if (aDone == bDone) return a.createdAt.compareTo(b.createdAt);
            return aDone ? 1 : -1;
          });
    return subjects;
  }

  Future<Task?> _taskByUuid(dynamic isar, String uuid) async {
    final tasks = await (isar as dynamic).tasks.where().findAll() as List<Task>;
    try {
      return tasks.firstWhere(
        (task) => task.uuid == uuid && task.tag == plannerSubjectTag,
      );
    } catch (_) {
      return null;
    }
  }
}
