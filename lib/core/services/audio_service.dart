import 'dart:async';

import 'package:audio_session/audio_session.dart' as audio_session;
import 'package:audioplayers/audioplayers.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';

class AudioTrack {
  const AudioTrack({
    required this.title,
    required this.artist,
    required this.assetPath,
  });

  final String title;
  final String artist;
  final String assetPath;
}

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer musicPlayer = AudioPlayer();
  final AudioPlayer ambientPlayer = AudioPlayer();
  final AudioPlayer sfxPlayer = AudioPlayer();

  static final List<AudioTrack> playlist = <AudioTrack>[
    const AudioTrack(
      title: 'Deep Work Beats',
      artist: 'FlowState Records',
      assetPath: 'audio/music/deep_work_beats.mp3',
    ),
    const AudioTrack(
      title: 'Lo-Fi Study Session',
      artist: 'FlowState Records',
      assetPath: 'audio/music/lofi_study.mp3',
    ),
    const AudioTrack(
      title: 'Focus Flow',
      artist: 'FlowState Records',
      assetPath: 'audio/music/focus_flow.mp3',
    ),
    const AudioTrack(
      title: 'Concentration Mode',
      artist: 'FlowState Records',
      assetPath: 'audio/music/deep_work_beats.mp3',
    ),
  ];

  static const Map<String, String> ambientAssets = <String, String>{
    'rain': 'audio/ambient/rain.mp3',
    'waves': 'audio/ambient/waves.mp3',
    'forest': 'audio/ambient/forest.mp3',
    'wind': 'audio/ambient/wind.mp3',
  };

  static const String completeSoundAsset = 'audio/sfx/complete.mp3';

  bool _initialized = false;
  audio_session.AudioSession? _audioSession;
  StreamSubscription<audio_session.AudioInterruptionEvent>? _interruptionSub;
  StreamSubscription<void>? _noisySub;
  StreamSubscription<BatteryState>? _batterySub;
  Timer? _lowBatteryTick;
  bool Function()? _isTimerRunning;
  double Function()? _ambientVolumeReader;
  VoidCallback? _onLowBatteryMode;

  Future<void> init({
    required bool Function() isTimerRunning,
    required double Function() ambientVolumeReader,
    VoidCallback? onLowBatteryMode,
  }) async {
    if (_initialized) return;
    _initialized = true;
    _isTimerRunning = isTimerRunning;
    _ambientVolumeReader = ambientVolumeReader;
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

    await ambientPlayer.setReleaseMode(ReleaseMode.loop);
    await sfxPlayer.setVolume(1);
    await musicPlayer.setVolume(0.8);
    await ambientPlayer.setVolume(0.4);

    _interruptionSub = _audioSession!.interruptionEventStream.listen((
      event,
    ) async {
      if (event.begin) {
        await musicPlayer.pause();
        await ambientPlayer.setVolume(0.2);
      } else if ((event.type == audio_session.AudioInterruptionType.pause ||
              event.type == audio_session.AudioInterruptionType.duck) &&
          (_isTimerRunning?.call() ?? false)) {
        await musicPlayer.resume();
        await ambientPlayer.setVolume(_ambientVolumeReader?.call() ?? 0.4);
      }
    });

    _noisySub = _audioSession!.becomingNoisyEventStream.listen((_) async {
      await musicPlayer.pause();
      await ambientPlayer.setVolume(0.2);
    });

    final battery = Battery();
    _batterySub = battery.onBatteryStateChanged.listen((state) async {
      if (state == BatteryState.discharging) {
        final level = await battery.batteryLevel;
        if (level <= 15) {
          await applyLowBatteryMode();
        }
      }
    });

    musicPlayer.onPlayerComplete.listen((_) async {
      await musicPlayer.seek(Duration.zero);
      await musicPlayer.resume();
    });
  }

  Future<void> applyLowBatteryMode() async {
    await musicPlayer.pause();
    await ambientPlayer.setVolume(0.15);
    _lowBatteryTick?.cancel();
    _lowBatteryTick = Timer.periodic(const Duration(minutes: 5), (_) {});
    _onLowBatteryMode?.call();
  }

  Future<void> verifyAudioAssets() async {
    final assets = [
      'assets/audio/ambient/rain.mp3',
      'assets/audio/ambient/waves.mp3',
      'assets/audio/ambient/forest.mp3',
      'assets/audio/ambient/wind.mp3',
      'assets/audio/music/deep_work_beats.mp3',
    ];
    for (final asset in assets) {
      try {
        await ambientPlayer.setSourceAsset(asset);
      } catch (error) {
        debugPrint('Audio asset missing or corrupt: $asset — $error');
      }
    }
  }

  Future<void> dispose() async {
    await _interruptionSub?.cancel();
    await _noisySub?.cancel();
    await _batterySub?.cancel();
    _lowBatteryTick?.cancel();
    await musicPlayer.dispose();
    await ambientPlayer.dispose();
    await sfxPlayer.dispose();
  }
}
