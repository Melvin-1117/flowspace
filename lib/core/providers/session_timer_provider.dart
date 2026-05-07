import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/pomodoro/providers/pomodoro_providers.dart'
    hide formattedTimeProvider, remainingSecondsProvider;
import '../models/pomodoro_session.dart';

// Compatibility provider for existing dashboard/task widgets.
final activeSessionProvider = Provider<PomodoroSession?>((ref) {
  final timer = ref.watch(timerNotifierProvider);
  final linkedId = timer.linkedTaskId;
  final linkedTitle = timer.linkedTaskTitle;
  if (linkedId == null || linkedTitle == null) return null;
  return PomodoroSession()
    ..uuid = ''
    ..sessionType = timer.sessionType.key
    ..linkedTaskId = linkedId
    ..linkedTaskTitle = linkedTitle
    ..startTime = timer.sessionStartAt ?? DateTime.now()
    ..plannedDurationSeconds = timer.totalDurationSeconds
    ..actualDurationSeconds =
        timer.totalDurationSeconds - timer.remainingSeconds
    ..isCompleted = false
    ..isAbandoned = false;
});

final sessionRunningProvider = Provider<bool>((ref) {
  return ref.watch(timerRunningProvider);
});

final remainingSecondsProvider = Provider<int>((ref) {
  return ref.watch(remainingSecondsProviderFromPomodoro);
});

final remainingSecondsProviderFromPomodoro = Provider<int>((ref) {
  return ref.watch(timerNotifierProvider).remainingSeconds;
});

final formattedTimeProvider = Provider<String>((ref) {
  final seconds = ref.watch(remainingSecondsProviderFromPomodoro);
  final minutes = seconds ~/ 60;
  final secs = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
});

class SessionTimerNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> startTimer(
    PomodoroSession session, {
    int? customFocusDurationSeconds,
  }) async {
    final timer = ref.read(timerNotifierProvider.notifier);
    final sessionType = SessionTypeFromName.fromName(session.sessionType);
    if (sessionType == SessionType.focus &&
        customFocusDurationSeconds != null &&
        customFocusDurationSeconds > 0) {
      await timer.startFocusWithDuration(
        durationSeconds: customFocusDurationSeconds,
        linkedTaskId: session.linkedTaskId,
        linkedTaskTitle: session.linkedTaskTitle,
      );
      return;
    }
    await timer.switchType(sessionType, force: true);
    await timer.start(
      linkedTaskId: session.linkedTaskId,
      linkedTaskTitle: session.linkedTaskTitle,
    );
  }

  Future<void> pauseTimer() async {
    await ref.read(timerNotifierProvider.notifier).pause();
  }

  Future<void> resumeTimer() async {
    await ref.read(timerNotifierProvider.notifier).resume();
  }

  Future<void> endTimer() async {
    await ref.read(timerNotifierProvider.notifier).reset();
  }
}

final sessionTimerProvider = NotifierProvider<SessionTimerNotifier, void>(
  SessionTimerNotifier.new,
);
