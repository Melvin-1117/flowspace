import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/milestone.dart';
import '../../../core/models/task.dart';
import '../../../core/providers/isar_provider.dart';
import '../../pomodoro/providers/pomodoro_web_store.dart';
import 'planner_providers.dart';
import 'planner_storage.dart';

class MilestoneNotifier extends AsyncNotifier<List<Milestone>> {
  @override
  Future<List<Milestone>> build() async {
    return _load();
  }

  // Creates and stores a milestone in planner persistence.
  Future<void> addMilestone(Milestone milestone) async {
    if (kIsWeb) return;
    final isar = await ref.read(isarProvider.future);
    final existing = await _taskByUuid(isar, milestone.uuid);
    await isar.writeTxn(() async {
      await (isar as dynamic).tasks.put(
        PlannerStorage.fromMilestone(milestone, existing: existing),
      );
    });
    state = AsyncData(await _load());
    ref.invalidate(allMilestonesProvider);
    ref.invalidate(nextMilestoneProvider);
    ref.invalidate(milestoneCountdownProvider);
    ref.invalidate(semesterHealthProvider);
  }

  // Marks milestone complete and persists timestamp.
  Future<void> completeMilestone(String uuid) async {
    final current = state.valueOrNull ?? <Milestone>[];
    final found = current
        .where((m) => m.uuid == uuid)
        .cast<Milestone?>()
        .firstOrNull;
    if (found == null) return;
    final updated = Milestone(
      id: found.id,
      uuid: found.uuid,
      title: found.title,
      description: found.description,
      linkedSubjectId: found.linkedSubjectId,
      dueDate: found.dueDate,
      priority: found.priority,
      isCompleted: true,
      completedAt: DateTime.now(),
      checklistItems: found.checklistItems,
      checklistCompleted: found.checklistCompleted,
    );
    await addMilestone(updated);
  }

  // Updates one checklist state for milestone preparation progress.
  Future<void> updateChecklist(String uuid, int index, bool value) async {
    final current = state.valueOrNull ?? <Milestone>[];
    final found = current
        .where((m) => m.uuid == uuid)
        .cast<Milestone?>()
        .firstOrNull;
    if (found == null ||
        index < 0 ||
        index >= found.checklistCompleted.length) {
      return;
    }
    final checklist = [...found.checklistCompleted]..[index] = value;
    final updated = Milestone(
      id: found.id,
      uuid: found.uuid,
      title: found.title,
      description: found.description,
      linkedSubjectId: found.linkedSubjectId,
      dueDate: found.dueDate,
      priority: found.priority,
      isCompleted: found.isCompleted,
      completedAt: found.completedAt,
      checklistItems: found.checklistItems,
      checklistCompleted: checklist,
    );
    await addMilestone(updated);
  }

  Future<List<Milestone>> _load() async {
    if (kIsWeb) return const <Milestone>[];
    final isar = await ref.read(isarProvider.future);
    final tasks = await (isar as dynamic).tasks.where().findAll() as List<Task>;
    return tasks
        .where((task) => task.tag == plannerMilestoneTag)
        .map(PlannerStorage.toMilestone)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  Future<Task?> _taskByUuid(dynamic isar, String uuid) async {
    final tasks = await (isar as dynamic).tasks.where().findAll() as List<Task>;
    try {
      return tasks.firstWhere(
        (task) => task.uuid == uuid && task.tag == plannerMilestoneTag,
      );
    } catch (_) {
      return null;
    }
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
