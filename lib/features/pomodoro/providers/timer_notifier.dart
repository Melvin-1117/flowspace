import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/focus_goal_settings.dart';
import '../../../core/models/pomodoro_session.dart';
import '../../../core/models/task.dart';
import '../../../core/providers/isar_provider.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/foreground_timer_service.dart';
import '../../../core/services/notification_service.dart';
import '../../tasks/providers/task_providers.dart';
import 'pomodoro_providers.dart';
import 'pomodoro_web_store.dart';

class TimerState {
  const TimerState({
    required this.sessionType,
    required this.totalDurationSeconds,
    required this.remainingSeconds,
    required this.isRunning,
    required this.completedFocusSessionsToday,
    required this.lastTickAt,
    this.sessionStartAt,
    this.linkedTaskId,
    this.linkedTaskTitle,
    this.completionOverlay,
    this.suggestedBreakType,
  });

  final SessionType sessionType;
  final int totalDurationSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final int completedFocusSessionsToday;
  final DateTime lastTickAt;
  final DateTime? sessionStartAt;
  final String? linkedTaskId;
  final String? linkedTaskTitle;
  final CompletionOverlayState? completionOverlay;
  final SessionType? suggestedBreakType;

  double get progress => totalDurationSeconds == 0
      ? 0
      : (remainingSeconds / totalDurationSeconds).clamp(0, 1).toDouble();

  TimerState copyWith({
    SessionType? sessionType,
    int? totalDurationSeconds,
    int? remainingSeconds,
    bool? isRunning,
    int? completedFocusSessionsToday,
    DateTime? lastTickAt,
    DateTime? sessionStartAt,
    bool clearSessionStartAt = false,
    String? linkedTaskId,
    String? linkedTaskTitle,
    bool clearLinkedTask = false,
    CompletionOverlayState? completionOverlay,
    bool clearOverlay = false,
    SessionType? suggestedBreakType,
    bool clearSuggestedBreak = false,
  }) {
    return TimerState(
      sessionType: sessionType ?? this.sessionType,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      completedFocusSessionsToday:
          completedFocusSessionsToday ?? this.completedFocusSessionsToday,
      lastTickAt: lastTickAt ?? this.lastTickAt,
      sessionStartAt: clearSessionStartAt
          ? null
          : (sessionStartAt ?? this.sessionStartAt),
      linkedTaskId: clearLinkedTask
          ? null
          : (linkedTaskId ?? this.linkedTaskId),
      linkedTaskTitle: clearLinkedTask
          ? null
          : (linkedTaskTitle ?? this.linkedTaskTitle),
      completionOverlay: clearOverlay
          ? null
          : (completionOverlay ?? this.completionOverlay),
      suggestedBreakType: clearSuggestedBreak
          ? null
          : (suggestedBreakType ?? this.suggestedBreakType),
    );
  }
}

class TimerNotifier extends Notifier<TimerState> {
  Timer? _ticker;
  DateTime? _runStartedAt;
  Duration _elapsedBeforeRun = Duration.zero;
  PomodoroSession? _activeSession;
  bool _bootstrapped = false;
  bool _foregroundActionsRegistered = false;
  final AudioPlayer _sfxPlayer = AudioPlayer();

  @override
  TimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      _sfxPlayer.dispose();
    });

    if (!_bootstrapped) {
      _bootstrapped = true;
      unawaited(_bootstrap());
    }

    return TimerState(
      sessionType: SessionType.focus,
      totalDurationSeconds: 1500,
      remainingSeconds: 1500,
      isRunning: false,
      completedFocusSessionsToday: 0,
      lastTickAt: DateTime.now(),
    );
  }

  Future<void> _bootstrap() async {
    await _sfxPlayer.setVolume(1);
    final settings = await ref.read(focusGoalSettingsProvider.future);
    final focusDuration = settings.focusDuration;
    final completedToday = kIsWeb
        ? _completedFocusCountWeb()
        : await _completedFocusCountToday(await ref.read(isarProvider.future));
    state = state.copyWith(
      sessionType: SessionType.focus,
      totalDurationSeconds: focusDuration,
      remainingSeconds: focusDuration,
      completedFocusSessionsToday: completedToday,
      lastTickAt: DateTime.now(),
    );

    await AudioService.instance.init(
      isTimerRunning: () => ref.read(timerRunningProvider),
      onLowBatteryMode: ForegroundTimerService.enableLowBatteryMode,
    );
    _registerForegroundActions();
  }

  void _registerForegroundActions() {
    if (_foregroundActionsRegistered) return;
    _foregroundActionsRegistered = true;
    ForegroundTimerService.registerActionListener((action) {
      switch (action) {
        case 'pause_resume':
          unawaited(togglePauseResume());
          break;
        case 'stop':
          unawaited(stopAndAbandon());
          break;
      }
    });
  }

  int _getDurationForType(SessionType type) {
    final settings = ref.read(focusGoalSettingsProvider).value;
    switch (type) {
      case SessionType.focus:
        return settings?.focusDuration ?? 1500;
      case SessionType.shortBreak:
        return settings?.shortBreakDuration ?? 300;
      case SessionType.longBreak:
        return settings?.longBreakDuration ?? 900;
    }
  }

  bool _shouldTakeLongBreak(int focusCount) {
    final interval =
        ref.read(focusGoalSettingsProvider).value?.longBreakInterval ?? 4;
    return focusCount != 0 && focusCount % interval == 0;
  }

  Future<void> applyNewDuration() async {
    final updated = _getDurationForType(state.sessionType);
    _elapsedBeforeRun = Duration.zero;
    _runStartedAt = null;
    state = state.copyWith(
      totalDurationSeconds: updated,
      remainingSeconds: updated,
      isRunning: false,
      clearSessionStartAt: true,
      clearLinkedTask: true,
      clearOverlay: true,
      clearSuggestedBreak: true,
      lastTickAt: DateTime.now(),
    );
    await _persistTimerState();
  }

  int elapsedSecondsAtNow() {
    if (state.sessionStartAt == null) return 0;
    if (!state.isRunning) return _elapsedBeforeRun.inSeconds;
    final currentSpan = _runStartedAt == null
        ? Duration.zero
        : DateTime.now().difference(_runStartedAt!);
    return (_elapsedBeforeRun + currentSpan).inSeconds;
  }

  Future<void> start({String? linkedTaskId, String? linkedTaskTitle}) async {
    if (state.isRunning) return;
    final now = DateTime.now();
    _activeSession ??= PomodoroSession()
      ..uuid = const Uuid().v4()
      ..sessionType = state.sessionType.key
      ..linkedTaskId = linkedTaskId
      ..linkedTaskTitle = linkedTaskTitle
      ..startTime = now
      ..plannedDurationSeconds = state.totalDurationSeconds
      ..actualDurationSeconds = 0
      ..isCompleted = false
      ..isAbandoned = false;

    _runStartedAt = DateTime.now();
    state = state.copyWith(
      isRunning: true,
      sessionStartAt: now,
      linkedTaskId: linkedTaskId,
      linkedTaskTitle: linkedTaskTitle,
      lastTickAt: DateTime.now(),
    );
    _startTicker();
    await _persistTimerState();
    await _startForegroundNotification();
  }

  Future<void> startFocusWithDuration({
    required int durationSeconds,
    String? linkedTaskId,
    String? linkedTaskTitle,
  }) async {
    final safeDuration = durationSeconds <= 0 ? 1500 : durationSeconds;
    _ticker?.cancel();
    _runStartedAt = null;
    _elapsedBeforeRun = Duration.zero;
    _activeSession = null;
    state = state.copyWith(
      sessionType: SessionType.focus,
      totalDurationSeconds: safeDuration,
      remainingSeconds: safeDuration,
      isRunning: false,
      clearSessionStartAt: true,
      clearLinkedTask: true,
      clearOverlay: true,
      clearSuggestedBreak: true,
      lastTickAt: DateTime.now(),
    );
    await _persistTimerState();
    await start(linkedTaskId: linkedTaskId, linkedTaskTitle: linkedTaskTitle);
  }

  Future<void> pause() async {
    if (!state.isRunning) return;
    if (_runStartedAt != null) {
      _elapsedBeforeRun += DateTime.now().difference(_runStartedAt!);
    }
    _runStartedAt = null;
    _ticker?.cancel();
    state = state.copyWith(isRunning: false, lastTickAt: DateTime.now());
    await _persistTimerState();
    await ForegroundTimerService.update(
      title: 'FlowSpace — ${state.sessionType.label}',
      text: '${_mmss(state.remainingSeconds)} remaining — Paused',
      isRunning: false,
    );
  }

  Future<void> resume() async {
    if (state.isRunning) return;
    _runStartedAt = DateTime.now();
    state = state.copyWith(isRunning: true, lastTickAt: DateTime.now());
    _startTicker();
    await _persistTimerState();
    await _startForegroundNotification();
  }

  Future<void> togglePauseResume() async {
    if (state.isRunning) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> stopAndAbandon() async {
    await reset();
  }

  Future<void> reset() async {
    _ticker?.cancel();
    _runStartedAt = null;
    if (_activeSession != null && elapsedSecondsAtNow() > 0) {
      await onSessionAbandoned(_activeSession!);
      _activeSession = null;
    }
    _elapsedBeforeRun = Duration.zero;
    final duration = _getDurationForType(state.sessionType);
    state = state.copyWith(
      totalDurationSeconds: duration,
      remainingSeconds: duration,
      isRunning: false,
      clearSessionStartAt: true,
      clearLinkedTask: true,
      clearOverlay: true,
      clearSuggestedBreak: true,
      lastTickAt: DateTime.now(),
    );
    await _persistTimerState();
    await ForegroundTimerService.stop();
  }

  Future<void> skip() async {
    final next = _nextType(after: state.sessionType);
    await switchType(next, force: true);
  }

  Future<void> switchType(SessionType type, {bool force = false}) async {
    if (!force && type == state.sessionType) return;
    if (_activeSession != null && elapsedSecondsAtNow() > 0) {
      await onSessionAbandoned(_activeSession!);
      _activeSession = null;
    }
    _ticker?.cancel();
    _runStartedAt = null;
    _elapsedBeforeRun = Duration.zero;
    final duration = _getDurationForType(type);
    state = state.copyWith(
      sessionType: type,
      totalDurationSeconds: duration,
      remainingSeconds: duration,
      isRunning: false,
      clearSessionStartAt: true,
      clearLinkedTask: true,
      clearOverlay: true,
      clearSuggestedBreak: true,
      lastTickAt: DateTime.now(),
    );
    await _persistTimerState();
  }

  Future<void> syncWithClock() async {
    if (!state.isRunning) return;
    final elapsed = elapsedSecondsAtNow();
    final nextRemaining = math.max(0, state.totalDurationSeconds - elapsed);
    state = state.copyWith(
      remainingSeconds: nextRemaining,
      lastTickAt: DateTime.now(),
    );
    if (nextRemaining == 0) {
      await complete();
      return;
    }
    await _persistTimerState();
  }

  Future<void> complete({bool fromRestore = false}) async {
    _ticker?.cancel();
    _runStartedAt = null;

    final completedType = state.sessionType;
    final elapsed = state.totalDurationSeconds;
    var completedFocus = state.completedFocusSessionsToday;
    if (completedType == SessionType.focus) {
      completedFocus += 1;
    }

    final breakType = _breakTypeForCount(completedFocus);
    final session =
        _activeSession ??
        (PomodoroSession()
          ..uuid = const Uuid().v4()
          ..sessionType = completedType.key
          ..linkedTaskId = state.linkedTaskId
          ..linkedTaskTitle = state.linkedTaskTitle
          ..startTime = DateTime.now().subtract(
            Duration(seconds: state.totalDurationSeconds),
          )
          ..plannedDurationSeconds = state.totalDurationSeconds
          ..actualDurationSeconds = elapsed
          ..isCompleted = false
          ..isAbandoned = false);
    await onSessionComplete(session);
    _activeSession = null;

    state = state.copyWith(
      isRunning: false,
      remainingSeconds: 0,
      completedFocusSessionsToday: completedFocus,
      completionOverlay: CompletionOverlayState(
        sessionType: completedType,
        actualDurationSeconds: elapsed,
      ),
      suggestedBreakType: completedType == SessionType.focus ? breakType : null,
      clearSessionStartAt: true,
      clearLinkedTask: true,
      lastTickAt: DateTime.now(),
    );

    if (!fromRestore) {
      await _sfxPlayer.play(AssetSource(AudioService.completeSoundAsset));
      await NotificationService.showSessionComplete(
        '${completedType.label} session complete! Great work 🎉',
      );
      for (var i = 0; i < 3; i++) {
        await HapticFeedback.heavyImpact();
      }
    }

    await ForegroundTimerService.stop();

    final autoStartBreaks =
        ref.read(focusGoalSettingsProvider).value?.autoStartBreaks ?? false;
    final autoStartFocus =
        ref.read(focusGoalSettingsProvider).value?.autoStartFocus ?? false;
    if (completedType == SessionType.focus) {
      await switchType(breakType, force: true);
      if (autoStartBreaks) {
        await start();
      }
    } else {
      await switchType(SessionType.focus, force: true);
      if (autoStartFocus) {
        await start();
      }
    }

    state = state.copyWith(
      completionOverlay: CompletionOverlayState(
        sessionType: completedType,
        actualDurationSeconds: elapsed,
      ),
      suggestedBreakType: completedType == SessionType.focus ? breakType : null,
    );
    await _persistTimerState();
  }

  Future<void> dismissCompletionOverlay() async {
    state = state.copyWith(clearOverlay: true, clearSuggestedBreak: true);
  }

  Future<void> startSuggestedBreak() async {
    final breakType = state.suggestedBreakType;
    if (breakType == null) return;
    await switchType(breakType, force: true);
    await start();
    await dismissCompletionOverlay();
  }

  Future<void> skipBreakAndFocus() async {
    await switchType(SessionType.focus, force: true);
    await dismissCompletionOverlay();
  }

  SessionType _breakTypeForCount(int focusCount) {
    if (_shouldTakeLongBreak(focusCount)) {
      return SessionType.longBreak;
    }
    return SessionType.shortBreak;
  }

  SessionType _nextType({required SessionType after}) {
    return switch (after) {
      SessionType.focus => _breakTypeForCount(
        state.completedFocusSessionsToday + 1,
      ),
      SessionType.shortBreak || SessionType.longBreak => SessionType.focus,
    };
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) async {
      final elapsed = elapsedSecondsAtNow();
      final nextRemaining = math.max(0, state.totalDurationSeconds - elapsed);
      state = state.copyWith(
        remainingSeconds: nextRemaining,
        lastTickAt: DateTime.now(),
      );
      if (nextRemaining == 0) {
        await complete();
        return;
      }
      if (nextRemaining % 60 == 0) {
        await ForegroundTimerService.pushTimerTick(
          formattedTime: _mmss(nextRemaining),
          isRunning: state.isRunning,
        );
      }
      await _persistTimerState();
    });
  }

  Future<void> _startForegroundNotification() async {
    await ForegroundTimerService.start(
      title: 'FlowSpace — ${state.sessionType.label} Session',
      text: '${_mmss(state.remainingSeconds)} remaining',
      isRunning: state.isRunning,
    );
  }

  Future<void> _persistTimerState() async {
    if (kIsWeb) {
      final settings = PomodoroWebStore.instance.ensureSettings();
      settings.wasTimerRunning = state.isRunning;
      settings.remainingSecondsOnKill = state.remainingSeconds;
      settings.sessionTypeOnKill = state.sessionType.key;
      settings.killTimestamp = DateTime.now();
      PomodoroWebStore.instance.updateSettings(settings);
      return;
    }
    final isar = await ref.read(isarProvider.future);
    final settings =
        await (isar as dynamic).focusGoalSettings.get(1) as FocusGoalSettings?;
    if (settings == null) return;
    settings.wasTimerRunning = state.isRunning;
    settings.remainingSecondsOnKill = state.remainingSeconds;
    settings.sessionTypeOnKill = state.sessionType.key;
    settings.killTimestamp = DateTime.now();
    await isar.writeTxn(
      () => (isar as dynamic).focusGoalSettings.put(settings),
    );
  }

  Future<void> restoreSession({
    required int remainingSeconds,
    required SessionType sessionType,
  }) async {
    _ticker?.cancel();
    _runStartedAt = DateTime.now();
    _elapsedBeforeRun = Duration(
      seconds: math.max(0, _getDurationForType(sessionType) - remainingSeconds),
    );
    state = state.copyWith(
      sessionType: sessionType,
      totalDurationSeconds: _getDurationForType(sessionType),
      remainingSeconds: remainingSeconds,
      isRunning: true,
      sessionStartAt: DateTime.now().subtract(_elapsedBeforeRun),
      lastTickAt: DateTime.now(),
    );
    _activeSession ??= PomodoroSession()
      ..uuid = const Uuid().v4()
      ..sessionType = sessionType.key
      ..startTime = state.sessionStartAt!
      ..plannedDurationSeconds = state.totalDurationSeconds
      ..actualDurationSeconds = 0
      ..isCompleted = false
      ..isAbandoned = false;
    _startTicker();
    await _startForegroundNotification();
    await _persistTimerState();
  }

  Future<void> handleExpiredWhileKilled() async {
    final settings = kIsWeb
        ? PomodoroWebStore.instance.ensureSettings()
        : await (await ref.read(isarProvider.future) as dynamic)
                  .focusGoalSettings
                  .get(1)
              as FocusGoalSettings?;
    final restoredType = SessionTypeFromName.fromName(
      settings?.sessionTypeOnKill ?? 'focus',
    );
    final planned = _getDurationForType(restoredType);
    final now = DateTime.now();
    final killTimestamp = settings?.killTimestamp ?? now;
    final consumed = math
        .max(
          0,
          math.min(planned, planned - (settings?.remainingSecondsOnKill ?? 0)),
        )
        .toInt();
    _activeSession = PomodoroSession()
      ..uuid = const Uuid().v4()
      ..sessionType = restoredType.key
      ..linkedTaskId = null
      ..linkedTaskTitle = null
      ..startTime = killTimestamp.subtract(Duration(seconds: consumed))
      ..plannedDurationSeconds = planned
      ..actualDurationSeconds = planned
      ..isCompleted = false
      ..isAbandoned = false;
    state = state.copyWith(
      sessionType: restoredType,
      totalDurationSeconds: planned,
      remainingSeconds: 0,
      isRunning: false,
      sessionStartAt: _activeSession!.startTime,
      lastTickAt: DateTime.now(),
    );
    await complete(fromRestore: true);
  }

  Future<void> saveCompletedSession({
    required PomodoroSession session,
    required bool wasCompleted,
    required bool wasAbandoned,
  }) async {
    final now = DateTime.now();
    session
      ..endTime = now
      ..actualDurationSeconds = now.difference(session.startTime).inSeconds
      ..isCompleted = wasCompleted
      ..isAbandoned = wasAbandoned;

    if (kIsWeb) {
      PomodoroWebStore.instance.upsertSession(session);
    } else {
      final isar = await ref.read(isarProvider.future);
      await isar.writeTxn(() async {
        await (isar as dynamic).pomodoroSessions.put(session);
      });
    }

    debugPrint(
      '[PomodoroSessionSave] uuid=${session.uuid} type=${session.sessionType} '
      'completed=$wasCompleted abandoned=$wasAbandoned '
      'planned=${session.plannedDurationSeconds}s actual=${session.actualDurationSeconds}s '
      'task=${session.linkedTaskId}',
    );

    ref.invalidate(todaySessionsProvider);
    ref.invalidate(dailyGoalProvider);
    ref.invalidate(weeklyHeatmapProvider);
    ref.invalidate(allSessionsProvider);
  }

  Future<void> onSessionComplete(PomodoroSession session) async {
    await saveCompletedSession(
      session: session,
      wasCompleted: true,
      wasAbandoned: false,
    );

    if (session.linkedTaskId != null) {
      if (kIsWeb) {
        final tasks = ref.read(taskNotifierProvider).valueOrNull ?? <Task>[];
        final task = tasks
            .where((item) => item.uuid == session.linkedTaskId!)
            .firstOrNull;
        if (task != null) {
          await ref
              .read(taskNotifierProvider.notifier)
              .updateTask(task.copyWith(pomodoroCount: task.pomodoroCount + 1));
          ref.invalidate(allTasksProvider);
          for (final status in const ['todo', 'inprogress', 'done']) {
            ref.invalidate(tasksByStatusProvider(status));
          }
        }
      } else {
        final isar = await ref.read(isarProvider.future);
        final tasks =
            await (isar as dynamic).tasks.where().findAll() as List<Task>;
        final task = tasks
            .where((item) => item.uuid == session.linkedTaskId!)
            .firstOrNull;
        if (task != null) {
          task.pomodoroCount += 1;
          task.updatedAt = DateTime.now();
          await isar.writeTxn(() => (isar as dynamic).tasks.put(task));
          ref.invalidate(allTasksProvider);
          for (final status in const ['todo', 'inprogress', 'done']) {
            ref.invalidate(tasksByStatusProvider(status));
          }
        }
      }
    }

    ref.invalidate(todaySessionsProvider);
    ref.invalidate(dailyGoalProvider);
    ref.invalidate(weeklyHeatmapProvider);
  }

  Future<void> onSessionAbandoned(PomodoroSession session) async {
    await saveCompletedSession(
      session: session,
      wasCompleted: false,
      wasAbandoned: true,
    );
  }

  Future<int> _completedFocusCountToday(Isar isar) async {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final sessions =
        await (isar as dynamic).pomodoroSessions.where().findAll()
            as List<PomodoroSession>;
    final todaysCompletedFocus = sessions.where(
      (session) =>
          session.sessionType == 'focus' &&
          session.isCompleted &&
          !session.startTime.isBefore(dayStart) &&
          session.startTime.isBefore(dayEnd),
    );
    return todaysCompletedFocus.length;
  }

  int _completedFocusCountWeb() {
    final now = DateTime.now();
    final dayStart = DateTime(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return PomodoroWebStore.instance.sessions
        .where(
          (session) =>
              session.sessionType == 'focus' &&
              session.isCompleted &&
              !session.startTime.isBefore(dayStart) &&
              session.startTime.isBefore(dayEnd),
        )
        .length;
  }

  String _mmss(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

extension on Iterable<Task> {
  Task? get firstOrNull => isEmpty ? null : first;
}
