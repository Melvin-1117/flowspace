import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/focus_block.dart';
import '../../../core/models/pomodoro_session.dart';
import '../../../core/models/task.dart';
import '../../../core/providers/isar_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/providers/session_timer_provider.dart';
import '../../pomodoro/providers/timer_notifier.dart';
import 'planner_providers.dart';
import 'planner_storage.dart';

class FocusBlockNotifier extends AsyncNotifier<List<FocusBlock>> {
  @override
  Future<List<FocusBlock>> build() async {
    return _load();
  }

  // Adds focus block and schedules reminder if enabled.
  Future<void> addBlock(FocusBlock block) async {
    if (kIsWeb) return;
    final isar = await ref.read(isarProvider.future);
    final existing = await _taskByUuid(isar, block.uuid);
    await isar.writeTxn(() async {
      await (isar as dynamic).tasks.put(
        PlannerStorage.fromFocusBlock(block, existing: existing),
      );
    });
    if (block.reminderEnabled) {
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
    ref.invalidate(todayFocusBlocksProvider);
    ref.invalidate(semesterHealthProvider);
  }

  // Marks block complete without launching a session.
  Future<void> completeBlock(String uuid) async {
    final current = state.valueOrNull ?? <FocusBlock>[];
    final found = current
        .where((b) => b.uuid == uuid)
        .cast<FocusBlock?>()
        .firstOrNull;
    if (found == null) return;
    await addBlock(
      FocusBlock(
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
      ),
    );
  }

  // Deletes focus block and cancels any scheduled reminders.
  Future<void> deleteBlock(String uuid) async {
    if (kIsWeb) return;
    final isar = await ref.read(isarProvider.future);
    final task = await _taskByUuid(isar, uuid);
    if (task == null) return;
    await isar.writeTxn(() async {
      await (isar as dynamic).tasks.delete(task.id);
    });
    await NotificationService.cancel(reminderNotificationId(uuid, 5));
    await NotificationService.cancel(reminderNotificationId(uuid, 10));
    await NotificationService.cancel(reminderNotificationId(uuid, 15));
    state = AsyncData(await _load());
    ref.invalidate(todayFocusBlocksProvider);
    ref.invalidate(semesterHealthProvider);
  }

  // Starts pomodoro timer using this block and navigates to timer screen.
  Future<void> startFocusSession(FocusBlock block) async {
    final session = PomodoroSession()
      ..uuid = ''
      ..sessionType = SessionType.focus.key
      ..linkedTaskId = block.linkedSubjectId
      ..linkedTaskTitle = block.title
      ..startTime = DateTime.now()
      ..plannedDurationSeconds = block.durationMinutes * 60
      ..actualDurationSeconds = 0
      ..isCompleted = false
      ..isAbandoned = false;
    await ref
        .read(sessionTimerProvider.notifier)
        .startTimer(
          session,
          customFocusDurationSeconds: block.durationMinutes * 60,
        );
  }

  Future<List<FocusBlock>> _load() async {
    if (kIsWeb) return const <FocusBlock>[];
    final isar = await ref.read(isarProvider.future);
    final tasks = await (isar as dynamic).tasks.where().findAll() as List<Task>;
    final now = DateTime.now();
    final blocks = tasks
        .where((task) => task.tag == plannerFocusBlockTag)
        .map(PlannerStorage.toFocusBlock)
        .toList();
    final adjusted = blocks.map((block) {
      final hasPassed = block.scheduledTime.isBefore(now);
      if (hasPassed && !block.isCompleted) {
        return FocusBlock(
          id: block.id,
          uuid: block.uuid,
          title: block.title,
          linkedSubjectId: block.linkedSubjectId,
          linkedTaskId: block.linkedTaskId,
          sessionType: block.sessionType,
          scheduledTime: block.scheduledTime,
          durationMinutes: block.durationMinutes,
          isCompleted: false,
          completedAt: block.completedAt,
          repeatRule: block.repeatRule,
          reminderEnabled: block.reminderEnabled,
          reminderMinutesBefore: block.reminderMinutesBefore,
        );
      }
      return block;
    }).toList()..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return adjusted;
  }

  Future<Task?> _taskByUuid(dynamic isar, String uuid) async {
    final tasks = await (isar as dynamic).tasks.where().findAll() as List<Task>;
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
