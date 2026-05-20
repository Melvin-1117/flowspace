import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../providers/pomodoro_providers.dart';

/// Listens to the accelerometer and automatically pauses / resumes the timer
/// when the user flips their phone face-down / face-up.
///
/// Only active during **focus** sessions. Flip pauses are FREE — they do NOT
/// consume trials.
class FlipDetectorService {
  FlipDetectorService(this._ref);

  final Ref _ref;
  StreamSubscription<AccelerometerEvent>? _subscription;
  bool _isFlipped = false;
  bool _isActive = false;

  /// Begin monitoring the accelerometer.
  /// Call when a focus session starts running.
  void startListening() {
    // Accelerometer is only available on mobile platforms.
    if (kIsWeb || _isUnsupportedDesktop) return;

    _isActive = true;
    _isFlipped = false;

    _subscription = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 500),
    ).listen((AccelerometerEvent event) {
      if (!_isActive) return;

      // Z axis:
      //   Positive (> +5) → screen facing UP   → normal
      //   Negative (< -5) → screen facing DOWN  → flipped
      final bool nowFlipped = event.z < -5.0;

      if (nowFlipped && !_isFlipped) {
        // Phone just flipped face down → pause
        _isFlipped = true;
        _ref.read(timerNotifierProvider.notifier).pauseFromFlip();
      } else if (!nowFlipped && _isFlipped) {
        // Phone just flipped back up → resume
        _isFlipped = false;
        _ref.read(timerNotifierProvider.notifier).resumeFromFlip();
      }
    });
  }

  /// Stop monitoring. Call when the timer stops or the screen disposes.
  void stopListening() {
    _isActive = false;
    _isFlipped = false;
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stopListening();
  }

  /// Returns true on desktop platforms where the accelerometer is unavailable.
  static bool get _isUnsupportedDesktop {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }
}

// ─── PROVIDER ───────────────────────────────────────────────────────────
final flipDetectorProvider = Provider<FlipDetectorService>((ref) {
  final service = FlipDetectorService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});
