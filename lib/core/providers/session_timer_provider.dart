import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_session.dart';

// Tracks if a session is currently active
final activeSessionProvider = StateProvider<PomodoroSession?>((ref) => null);

// Tracks running/paused state
final sessionRunningProvider = StateProvider<bool>((ref) => false);

// Tracks remaining seconds (live countdown)
final remainingSecondsProvider = StateProvider<int>((ref) => 0);

// Formatted time string MM:SS
final formattedTimeProvider = Provider<String>((ref) {
  final seconds = ref.watch(remainingSecondsProvider);
  final minutes = seconds ~/ 60;
  final secs = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
});

// Timer controller notifier
class SessionTimerNotifier extends Notifier<void> {
  Timer? _timer;

  @override
  void build() {}

  void startTimer(PomodoroSession session) {
    ref.read(activeSessionProvider.notifier).state = session;
    ref.read(remainingSecondsProvider.notifier).state = session.remainingSeconds;
    ref.read(sessionRunningProvider.notifier).state = true;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = ref.read(remainingSecondsProvider) - 1;
      if (remaining <= 0) {
        ref.read(remainingSecondsProvider.notifier).state = 0;
        endTimer();
      } else {
        ref.read(remainingSecondsProvider.notifier).state = remaining;
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    ref.read(sessionRunningProvider.notifier).state = false;
  }

  void resumeTimer() {
    ref.read(sessionRunningProvider.notifier).state = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = ref.read(remainingSecondsProvider) - 1;
      if (remaining <= 0) {
        ref.read(remainingSecondsProvider.notifier).state = 0;
        endTimer();
      } else {
        ref.read(remainingSecondsProvider.notifier).state = remaining;
      }
    });
  }

  void endTimer() {
    _timer?.cancel();
    ref.read(sessionRunningProvider.notifier).state = false;
    ref.read(activeSessionProvider.notifier).state = null;
  }
}

final sessionTimerProvider = NotifierProvider<SessionTimerNotifier, void>(() {
  return SessionTimerNotifier();
});
