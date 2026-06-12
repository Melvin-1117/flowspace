import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/milestone.dart';
import '../../../core/models/subject.dart';
import '../../../core/models/subject_module.dart';
import '../../../core/models/task.dart';
import '../../../core/providers/isar_provider.dart';
import 'package:isar/isar.dart';
import 'planner_providers.dart';
import 'planner_storage.dart';

class SubjectNotifier extends AsyncNotifier<List<Subject>> {
  static final List<Subject> _webSubjects = [];

  @override
  Future<List<Subject>> build() async {
    return _load();
  }

  // Creates and persists a planner subject.
  Future<void> addSubject(Subject subject) async {
    if (kIsWeb) {
      _webSubjects.add(subject);
      state = AsyncData([..._webSubjects]);
      ref.invalidate(allSubjectsProvider);
      ref.invalidate(semesterHealthProvider);
      return;
    }
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      await isar.collection<Task>().put(PlannerStorage.fromSubject(subject));
    });
    state = AsyncData(await _load());
    ref.invalidate(allSubjectsProvider);
    ref.invalidate(semesterHealthProvider);
  }

  // Updates planner subject fields and module progress.
  Future<void> updateSubject(Subject subject) async {
    if (kIsWeb) {
      final idx = _webSubjects.indexWhere((s) => s.uuid == subject.uuid);
      if (idx >= 0) {
        _webSubjects[idx] = subject;
      }
      state = AsyncData([..._webSubjects]);
      ref.invalidate(allSubjectsProvider);
      ref.invalidate(semesterHealthProvider);
      return;
    }
    final isar = await ref.read(isarProvider.future);
    final existing = await _taskByUuid(isar, subject.uuid);
    await isar.writeTxn(() async {
      await isar.collection<Task>().put(
        PlannerStorage.fromSubject(subject, existing: existing),
      );
    });
    state = AsyncData(await _load());
    ref.invalidate(allSubjectsProvider);
    ref.invalidate(semesterHealthProvider);
  }

  // Deletes subject and linked planner records.
  Future<void> deleteSubject(String uuid) async {
    if (kIsWeb) {
      _webSubjects.removeWhere((s) => s.uuid == uuid);
      state = AsyncData([..._webSubjects]);
      ref.invalidate(allSubjectsProvider);
      ref.invalidate(allMilestonesProvider);
      ref.invalidate(todayFocusBlocksProvider);
      ref.invalidate(semesterHealthProvider);
      return;
    }
    final isar = await ref.read(isarProvider.future);
    final all = await isar.collection<Task>().where().findAll();
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
        await isar.collection<Task>().delete(id);
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

  Future<void> toggleModuleCompletion(
    String subjectUuid,
    String moduleUuid,
    bool isCompleted,
  ) async {
    final current = state.valueOrNull ?? <Subject>[];
    final index = current.indexWhere((s) => s.uuid == subjectUuid);
    if (index < 0) return;
    final subject = current[index];
    final modules = subject.modules.map((m) {
      if (m.uuid == moduleUuid) {
        return SubjectModule(
          id: m.id,
          uuid: m.uuid,
          subjectId: m.subjectId,
          name: m.name,
          moduleNumber: m.moduleNumber,
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : null,
          linkedNoteIds: m.linkedNoteIds,
        );
      }
      return m;
    }).toList();

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

  Future<void> addModule(String subjectUuid, String moduleName) async {
    final current = state.valueOrNull ?? <Subject>[];
    final index = current.indexWhere((s) => s.uuid == subjectUuid);
    if (index < 0) return;
    final subject = current[index];
    final modules = [...subject.modules];
    int nextNumber = 1;
    for (final m in modules) {
      if (m.moduleNumber >= nextNumber) {
        nextNumber = m.moduleNumber + 1;
      }
    }
    modules.add(SubjectModule(
      uuid: const Uuid().v4(),
      subjectId: subject.uuid,
      name: moduleName,
      moduleNumber: nextNumber,
      isCompleted: false,
      completedAt: null,
      linkedNoteIds: const <String>[],
    ));

    final updated = Subject(
      id: subject.id,
      uuid: subject.uuid,
      name: subject.name,
      iconName: subject.iconName,
      colorHex: subject.colorHex,
      totalModules: subject.totalModules + 1,
      completedModules: modules.where((m) => m.isCompleted).length,
      examDate: subject.examDate,
      weeklyGoalHours: subject.weeklyGoalHours,
      createdAt: subject.createdAt,
      modules: modules,
    );
    await updateSubject(updated);
  }

  Future<List<Subject>> _load() async {
    if (kIsWeb) return _webSubjects;
    final isar = await ref.read(isarProvider.future);
    final tasks = await isar.collection<Task>().where().findAll();
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

  Future<Task?> _taskByUuid(Isar isar, String uuid) async {
    final tasks = await isar.collection<Task>().where().findAll();
    try {
      return tasks.firstWhere(
        (task) => task.uuid == uuid && task.tag == plannerSubjectTag,
      );
    } catch (_) {
      return null;
    }
  }
}
