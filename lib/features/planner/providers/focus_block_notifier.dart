import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/focus_block.dart';
import '../../../core/models/task.dart';
import '../../../core/models/task_isar.dart';
import '../../../core/providers/isar_provider.dart';
import 'package:isar/isar.dart';
import '../../../core/services/notification_service.dart';
import '../../pomodoro/providers/pomodoro_providers.dart';
import '../../pomodoro/providers/pomodoro_web_store.dart';
import 'planner_providers.dart';
import 'planner_storage.dart';

class FocusBlockNotifier extends AsyncNotifier<List<FocusBlock>> {
  @override
  Future<List<FocusBlock>> build() async {
    return _load();
  }

  Future<void> addBlock(FocusBlock block) async {
    if (kIsWeb) return;
    final isar = await ref.read(isarProvider.future);
    final existing = await _taskByUuid(isar, block.uuid);
    await isar.writeTxn(() async {
      await isar.tasks.put(
        PlannerStorage.fromFocusBlock(block, existing: existing),
      );
    });

    if (!block.reminderEnabled) {
      // nothing to schedule
    } else {
      await NotificationService.scheduleFocusBlockReminder(
        notificationId: reminderNotificationId(
          block.uuid,
          block.reminderMinutesBefore,
        ),
        title: 'Focus Block Starting Soon',
        body: '${block.title} in ${block.reminderMinutesBefore} mins',
        scheduledAt: block.scheduledTime.subtract(
          Duration(minutes: block.reminderMinutesBefore),
        ),
        payload: '/planner',
      );
    }

    state = AsyncData(await _load());
    ref.invalidate(plannerNotificationBootstrapProvider);
    ref.invalidate(todayFocusBlocksProvider);
    ref.invalidate(semesterHealthProvider);
  }

  Future<void> completeBlock(String uuid) async {
    final current = state.valueOrNull ?? <FocusBlock>[];
    final found = current
        .where((b) => b.uuid == uuid)
        .cast<FocusBlock?>()
        .firstOrNull;
    if (found == null) return;
    final updated = FocusBlock(
      id: found.id,
      uuid: found.uuid,
      title: found.title,
      linkedSubjectId: found.linkedSubjectId,
      linkedTaskId: found.linkedTaskId,
      sessionType: found.sessionType,
      scheduledTime: found.scheduledTime,
      durationMinutes: found.durationMinutes,
      isCompleted: true,
      completedAt: DateTime.now(),
      repeatRule: found.repeatRule,
      reminderEnabled: found.reminderEnabled,
      reminderMinutesBefore: found.reminderMinutesBefore,
    );
    await addBlock(updated);
  }

  Future<void> deleteBlock(String uuid) async {
    if (kIsWeb) return;
    final isar = await ref.read(isarProvider.future);
    final tasks = await isar.tasks.where().findAll() as List<Task>;
    final found = tasks
        .where((t) => t.uuid == uuid && t.tag == plannerFocusBlockTag)
        .firstOrNull;
    if (found == null) return;
    await isar.writeTxn(() async {
      await isar.tasks.delete(found.id);
    });
    ref.invalidate(todayFocusBlocksProvider);
    state = AsyncData(await _load());
  }

  Future<void> startFocusSession(FocusBlock block) async {
    final durationSeconds = block.durationMinutes * 60;
    await ref
        .read(timerNotifierProvider.notifier)
        .startFocusWithDuration(
          durationSeconds: durationSeconds,
          linkedTaskId: block.uuid,
          linkedTaskTitle: block.title,
        );
  }

  Future<List<FocusBlock>> _load() async {
    if (kIsWeb) return const <FocusBlock>[];
    final isar = await ref.read(isarProvider.future);
    final tasks = await isar.tasks.where().findAll() as List<Task>;
    return tasks
        .where((task) => task.tag == plannerFocusBlockTag)
        .map(PlannerStorage.toFocusBlock)
        .toList()
      ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
  }

  Future<Task?> _taskByUuid(Isar isar, String uuid) async {
    final tasks = await isar.tasks.where().findAll() as List<Task>;
    try {
      return tasks.firstWhere(
        (task) => task.uuid == uuid && task.tag == plannerFocusBlockTag,
      );
    } catch (_) {
      return null;
    }
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
