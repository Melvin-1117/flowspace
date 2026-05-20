import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pomodoro_providers.dart';

/// Manages the alarm sound + vibration pattern that fires when a session
/// reaches 0:00. The alarm loops until the user explicitly dismisses it.
class AlarmService {
  final AudioPlayer _player = AudioPlayer();
  Timer? _repeatTimer;
  bool _isRinging = false;

  /// Start the alarm loop. No-ops if already ringing.
  Future<void> startAlarm() async {
    if (_isRinging) return;
    _isRinging = true;

    // Play alarm at full volume on loop
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(1.0);
    await _player.play(AssetSource('audio/sfx/alarm.mp3'));

    // Immediate vibration burst
    _vibrate();

    // Repeat vibration every 30 seconds if not dismissed
    _repeatTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (_isRinging) _vibrate();
      },
    );
  }

  void _vibrate() {
    // Use HapticFeedback on all platforms — no external vibration package
    // needed. On desktop this is a no-op.
    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 700), () {
        HapticFeedback.heavyImpact();
      });
    }
  }

  /// Silence the alarm and cancel vibration.
  Future<void> dismissAlarm() async {
    if (!_isRinging) return;
    _isRinging = false;
    _repeatTimer?.cancel();
    _repeatTimer = null;
    await _player.stop();
  }

  bool get isRinging => _isRinging;

  void dispose() {
    dismissAlarm();
    _player.dispose();
  }
}

// ─── PROVIDERS ──────────────────────────────────────────────────────────

final alarmServiceProvider = Provider<AlarmService>((ref) {
  final service = AlarmService();
  ref.onDispose(() => service.dispose());
  return service;
});

final alarmOverlayVisibleProvider = StateProvider<bool>((ref) => false);

final isLastBeforeLongProvider = Provider<bool>((ref) {
  final count = ref.watch(sessionCountProvider);
  final settings = ref.watch(focusGoalSettingsProvider).value;
  final interval = settings?.longBreakInterval ?? 4;
  return interval > 0 && count > 0 && count % interval == 0;
});
