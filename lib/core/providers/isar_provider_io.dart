import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/focus_goal_settings.dart';
import '../models/pomodoro_session.dart';
import '../models/project.dart';
import '../models/study_event.dart';
import '../models/task.dart';
import '../models/task_activity.dart';
import '../models/user_profile.dart';

const _isarName = 'flowspace';
const _isarSchemaVersion = 3;

final isarProvider = FutureProvider<Isar>((ref) async {
  final existing = Isar.getInstance(_isarName);
  if (existing != null) return existing;

  final directory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      TaskSchema,
      ProjectSchema,
      TaskActivitySchema,
      PomodoroSessionSchema,
      FocusGoalSettingsSchema,
      StudyEventSchema,
      UserProfileSchema,
    ],
    name: _isarName,
    directory: directory.path,
    inspector: false,
  );
  await _ensureFocusSettings(isar);
  await _runSchemaMigrations(isar, _isarSchemaVersion);
  return isar;
});

Future<void> _ensureFocusSettings(Isar isar) async {
  final settings = await isar.focusGoalSettings.get(1);
  if (settings != null) return;
  final defaults = FocusGoalSettings()
    ..id = 1
    ..focusDuration = 1500
    ..shortBreakDuration = 300
    ..longBreakDuration = 900
    ..dailySessionGoal = 4
    ..longBreakInterval = 4
    ..autoStartBreaks = false
    ..autoStartFocus = false
    ..ambientVolume = 0.4
    ..musicVolume = 0.8
    ..lastAmbientSound = null
    ..wasTimerRunning = false
    ..remainingSecondsOnKill = 1500
    ..sessionTypeOnKill = 'focus'
    ..killTimestamp = null;
  await isar.writeTxn(() async {
    await isar.focusGoalSettings.put(defaults);
  });
}

Future<void> _runSchemaMigrations(Isar isar, int schemaVersion) async {
  if (schemaVersion >= 2) {
    await _migratePomodoroSessionsV2(isar);
  }
}

Future<void> _migratePomodoroSessionsV2(Isar isar) async {
  final settings = await isar.focusGoalSettings.get(1);
  final sessions = await isar.pomodoroSessions.where().findAll();
  if (sessions.isEmpty) return;
  final uuid = const Uuid();
  final focusDuration = settings?.focusDuration ?? 1500;
  final shortBreakDuration = settings?.shortBreakDuration ?? 300;
  final longBreakDuration = settings?.longBreakDuration ?? 900;

  for (final session in sessions) {
    var dirty = false;
    if (session.uuid.trim().isEmpty) {
      session.uuid = uuid.v4();
      dirty = true;
    }
    if (session.sessionType.trim().isEmpty) {
      final taskRef = session.linkedTaskId ?? '';
      if (taskRef.contains('longbreak')) {
        session.sessionType = 'longbreak';
      } else if (taskRef.contains('shortbreak')) {
        session.sessionType = 'shortbreak';
      } else {
        session.sessionType = 'focus';
      }
      dirty = true;
    }
    if (session.plannedDurationSeconds <= 0) {
      session.plannedDurationSeconds = switch (session.sessionType) {
        'shortbreak' => shortBreakDuration,
        'longbreak' => longBreakDuration,
        _ => focusDuration,
      };
      dirty = true;
    }
    if (session.actualDurationSeconds <= 0) {
      session.actualDurationSeconds = session.endTime == null
          ? 0
          : session.endTime!.difference(session.startTime).inSeconds;
      dirty = true;
    }
    if (!session.isCompleted && !session.isAbandoned) {
      session.isAbandoned = true;
      dirty = true;
    }
    if (session.isCompleted && session.endTime == null) {
      session.endTime = session.startTime.add(
        Duration(seconds: session.plannedDurationSeconds),
      );
      dirty = true;
    }
    if (dirty) {
      await isar.writeTxn(() async {
        await isar.pomodoroSessions.put(session);
      });
    }
  }
}
