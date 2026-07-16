import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../providers/focus_lock_notifier.dart';

/// Dedicated accelerometer listener for Focus Lock Mode.
///
/// **Opposite behaviour** to the existing [FlipDetectorService]:
/// - Face DOWN → session active / resume
/// - Face UP   → strike (distraction detected)
///
/// Only active on mobile platforms.
class FocusLockFlipDetector {
  StreamSubscription<AccelerometerEvent>? _sub;
  bool _isPhoneDown = false;

  /// Whether the detector is currently monitoring.
  bool get isMonitoring => _sub != null;

  /// Start listening to the accelerometer.
  void startMonitoring(WidgetRef ref) {
    if (kIsWeb || _isUnsupportedDesktop) return;

    _isPhoneDown = false;
    _sub?.cancel();

    int consecutiveDown = 0;
    int consecutiveUp = 0;

    _sub = accelerometerEventStream(
      // Sample slightly faster (200ms) but require 3 consecutive samples (600ms stable)
      samplingPeriod: const Duration(milliseconds: 200),
    ).listen((AccelerometerEvent event) {
      // Z < -5.5 → screen is facing DOWN
      final isDown = event.z < -5.5;

      if (isDown) {
        consecutiveDown++;
        consecutiveUp = 0;
        if (consecutiveDown >= 3 && !_isPhoneDown) {
          _isPhoneDown = true;
          ref.read(focusLockNotifierProvider.notifier).onPhoneFlippedDown();
        }
      } else {
        consecutiveUp++;
        consecutiveDown = 0;
        if (consecutiveUp >= 3 && _isPhoneDown) {
          _isPhoneDown = false;
          ref.read(focusLockNotifierProvider.notifier).onPhoneFlippedUp();
        }
      }
    });
  }

  /// Stop monitoring.
  void stopMonitoring() {
    _sub?.cancel();
    _sub = null;
    _isPhoneDown = false;
  }

  void dispose() {
    stopMonitoring();
  }

  static bool get _isUnsupportedDesktop {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────
final focusLockFlipDetectorProvider =
    Provider<FocusLockFlipDetector>((ref) {
  final detector = FocusLockFlipDetector();
  ref.onDispose(() => detector.dispose());
  return detector;
});
