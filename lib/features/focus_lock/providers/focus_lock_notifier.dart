import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/isar_provider.dart';
import '../models/focus_lock_session.dart';
import 'focus_lock_providers.dart';

// ── Status enum ──────────────────────────────────────────────────────────────
enum FocusLockStatus {
  idle,
  waitingForFlip,
  active,
  strikeWarning,
  void_,
  complete,
}

// ── State ────────────────────────────────────────────────────────────────────
class FocusLockState {
  const FocusLockState({
    this.status = FocusLockStatus.idle,
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.strikes = 0,
    this.showStrikeWarning = false,
    this.isVoid = false,
    this.isComplete = false,
    this.startedAt,
  });

  final FocusLockStatus status;
  final int totalSeconds;
  final int remainingSeconds;
  final int strikes;
  final bool showStrikeWarning;
  final bool isVoid;
  final bool isComplete;
  final DateTime? startedAt;

  int get elapsedSeconds => totalSeconds - remainingSeconds;

  double get progress =>
      totalSeconds == 0 ? 0 : 1 - (remainingSeconds / totalSeconds);

  String get formattedTime {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  FocusLockState copyWith({
    FocusLockStatus? status,
    int? totalSeconds,
    int? remainingSeconds,
    int? strikes,
    bool? showStrikeWarning,
    bool? isVoid,
    bool? isComplete,
    DateTime? startedAt,
  }) {
    return FocusLockState(
      status: status ?? this.status,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      strikes: strikes ?? this.strikes,
      showStrikeWarning: showStrikeWarning ?? this.showStrikeWarning,
      isVoid: isVoid ?? this.isVoid,
      isComplete: isComplete ?? this.isComplete,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────
class FocusLockNotifier extends Notifier<FocusLockState> {
  Timer? _ticker;

  @override
  FocusLockState build() => const FocusLockState();

  /// Prepare a new session (called from entry screen before flip).
  void prepareSession(int durationMinutes) {
    _ticker?.cancel();
    final seconds = durationMinutes * 60;
    state = FocusLockState(
      status: FocusLockStatus.waitingForFlip,
      totalSeconds: seconds,
      remainingSeconds: seconds,
      strikes: 0,
      isVoid: false,
      isComplete: false,
      startedAt: DateTime.now(),
    );
  }

  static const _lockTaskChannel = MethodChannel('com.flowspaceapp.flowspace/lock_task');

  Future<void> _startAndroidLockTask() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _lockTaskChannel.invokeMethod('startLockTask');
    } catch (e) {
      debugPrint('FocusLock: Failed to start Lock Task: $e');
    }
  }

  Future<void> _stopAndroidLockTask() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _lockTaskChannel.invokeMethod('stopLockTask');
    } catch (e) {
      debugPrint('FocusLock: Failed to stop Lock Task: $e');
    }
  }

  /// Phone placed face down → start/resume timer.
  void onPhoneFlippedDown() {
    if (state.status != FocusLockStatus.waitingForFlip &&
        state.status != FocusLockStatus.strikeWarning) {
      return;
    }

    state = state.copyWith(
      status: FocusLockStatus.active,
      showStrikeWarning: false,
    );
    _startTicker();
    _startAndroidLockTask();
  }

  /// Phone lifted → register a strike.
  void onPhoneFlippedUp() {
    if (state.status != FocusLockStatus.active) return;

    _ticker?.cancel();

    final newStrikes = state.strikes + 1;

    // Haptic feedback
    HapticFeedback.heavyImpact();

    if (newStrikes >= 3) {
      _voidSession();
      return;
    }

    state = state.copyWith(
      status: FocusLockStatus.strikeWarning,
      strikes: newStrikes,
      showStrikeWarning: true,
    );
  }

  /// Dismiss the strike warning overlay.
  void dismissStrikeWarning() {
    state = state.copyWith(
      showStrikeWarning: false,
      status: FocusLockStatus.waitingForFlip,
    );
  }

  /// App backgrounded during session → treat as phone lifted.
  void addStrikeFromBackground() {
    onPhoneFlippedUp();
  }

  /// Reset state back to idle.
  void reset() {
    _ticker?.cancel();
    state = const FocusLockState();
    _stopAndroidLockTask();
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 1) {
        _completeSession();
        return;
      }
      state = state.copyWith(
        remainingSeconds: state.remainingSeconds - 1,
      );
    });
  }

  void _completeSession() {
    _ticker?.cancel();
    state = state.copyWith(
      isComplete: true,
      remainingSeconds: 0,
      status: FocusLockStatus.complete,
    );

    // Haptic celebration
    HapticFeedback.heavyImpact();

    _saveToIsar();
    _stopAndroidLockTask();
  }

  void _voidSession() {
    _ticker?.cancel();
    state = state.copyWith(
      isVoid: true,
      strikes: 3,
      showStrikeWarning: false,
      status: FocusLockStatus.void_,
    );
    // Voided sessions are NOT saved
    HapticFeedback.heavyImpact();
    _stopAndroidLockTask();
  }

  Future<void> _saveToIsar() async {
    final session = FocusLockSession()
      ..uuid = const Uuid().v4()
      ..durationMinutes = state.totalSeconds ~/ 60
      ..strikes = state.strikes
      ..isCompleted = true
      ..isVoid = false
      ..startedAt = state.startedAt ?? DateTime.now()
      ..completedAt = DateTime.now()
      ..focusScore = calculateFocusScore(
        state.totalSeconds ~/ 60,
        state.strikes,
      );

    if (kIsWeb) {
      try {
        await saveFocusLockSessionToPrefs(session);
        ref.invalidate(todayFocusLockSessionsProvider);
      } catch (e) {
        debugPrint('FocusLock: Failed to save web session: $e');
      }
      return;
    }

    try {
      final isar = await ref.read(isarProvider.future);
      await isar.writeTxn(() async {
        await isar.collection<FocusLockSession>().put(session);
      });

      // Invalidate stats so UI updates
      ref.invalidate(todayFocusLockSessionsProvider);
    } catch (e) {
      debugPrint('FocusLock: Failed to save session: $e');
    }
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────
final focusLockNotifierProvider =
    NotifierProvider<FocusLockNotifier, FocusLockState>(
  FocusLockNotifier.new,
);

// ── Focus score calculation ──────────────────────────────────────────────────
int calculateFocusScore(int minutes, int strikes) {
  final base = minutes * 2;
  final penalty = strikes * (minutes ~/ 3);
  return (base - penalty).clamp(0, base);
}

String focusScoreLabel(int minutes, int strikes) {
  final base = minutes * 2;
  final score = calculateFocusScore(minutes, strikes);
  if (score >= base * 0.9) return '$score ⭐ S Rank';
  if (score >= base * 0.7) return '$score A Rank';
  if (score >= base * 0.5) return '$score B Rank';
  return '$score C Rank';
}
