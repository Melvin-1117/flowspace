import 'dart:async';

import 'package:audio_session/audio_session.dart' as audio_session;
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  static const String completeSoundAsset = 'audio/sfx/complete.mp3';

  bool _initialized = false;
  audio_session.AudioSession? _audioSession;
  StreamSubscription<audio_session.AudioInterruptionEvent>? _interruptionSub;
  StreamSubscription<void>? _noisySub;
  StreamSubscription<BatteryState>? _batterySub;
  Timer? _lowBatteryTick;
  VoidCallback? _onLowBatteryMode;

  Future<void> init({
    required bool Function() isTimerRunning,
    VoidCallback? onLowBatteryMode,
  }) async {
    if (_initialized) return;
    _initialized = true;
    _onLowBatteryMode = onLowBatteryMode;

    _audioSession = await audio_session.AudioSession.instance;
    await _audioSession!.configure(
      const audio_session.AudioSessionConfiguration(
        avAudioSessionCategory: audio_session.AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            audio_session.AVAudioSessionCategoryOptions.mixWithOthers,
        androidAudioAttributes: audio_session.AndroidAudioAttributes(
          contentType: audio_session.AndroidAudioContentType.music,
          usage: audio_session.AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType:
            audio_session.AndroidAudioFocusGainType.gainTransientMayDuck,
      ),
    );

    _interruptionSub = _audioSession!.interruptionEventStream.listen(
      (event) async {},
    );

    _noisySub = _audioSession!.becomingNoisyEventStream.listen((_) async {});

    final battery = Battery();
    _batterySub = battery.onBatteryStateChanged.listen((state) async {
      if (state == BatteryState.discharging) {
        final level = await battery.batteryLevel;
        if (level <= 15) {
          await applyLowBatteryMode();
        }
      }
    });
  }

  Future<void> applyLowBatteryMode() async {
    _lowBatteryTick?.cancel();
    _lowBatteryTick = Timer.periodic(const Duration(minutes: 5), (_) {});
    _onLowBatteryMode?.call();
  }

  Future<void> verifyAudioAssets() async {}

  Future<void> dispose() async {
    await _interruptionSub?.cancel();
    await _noisySub?.cancel();
    await _batterySub?.cancel();
    _lowBatteryTick?.cancel();
  }
}
