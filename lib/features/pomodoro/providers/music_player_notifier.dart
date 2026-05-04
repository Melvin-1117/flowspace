import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/isar_provider.dart';
import '../../../core/services/audio_service.dart';
import 'pomodoro_web_store.dart';

class MusicState {
  const MusicState({
    required this.currentTrack,
    required this.isPlaying,
    required this.volume,
  });

  final AudioTrack currentTrack;
  final bool isPlaying;
  final double volume;

  String get currentTrackName => currentTrack.title;

  MusicState copyWith({
    AudioTrack? currentTrack,
    bool? isPlaying,
    double? volume,
  }) {
    return MusicState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
    );
  }
}

class MusicPlayerNotifier extends StateNotifier<MusicState> {
  MusicPlayerNotifier(this.ref)
    : super(
        MusicState(
          currentTrack: AudioService.playlist.first,
          isPlaying: false,
          volume: 0.8,
        ),
      ) {
    _init();
  }

  final Ref ref;
  final _service = AudioService.instance;
  int _trackIndex = 0;

  Future<void> _init() async {
    await _service.verifyAudioAssets();
    final settings = kIsWeb
        ? PomodoroWebStore.instance.ensureSettings()
        : await (await ref.read(isarProvider.future) as dynamic)
                .focusGoalSettings
                .get(1) as dynamic;
    final volume = settings?.musicVolume ?? 0.8;
    await setVolume(volume);
  }

  Future<void> _playCurrent() async {
    final track = AudioService.playlist[_trackIndex];
    await _service.musicPlayer.setSourceAsset('assets/${track.assetPath}');
    await _service.musicPlayer.resume();
    state = state.copyWith(currentTrack: track, isPlaying: true);
  }

  Future<void> play() async {
    await _playCurrent();
  }

  Future<void> pause() async {
    await _service.musicPlayer.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> togglePlayback() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> next() async {
    _trackIndex = (_trackIndex + 1) % AudioService.playlist.length;
    await _playCurrent();
  }

  Future<void> previous() async {
    _trackIndex = (_trackIndex - 1 + AudioService.playlist.length) %
        AudioService.playlist.length;
    await _playCurrent();
  }

  Future<void> setVolume(double value) async {
    await _service.musicPlayer.setVolume(value);
    state = state.copyWith(volume: value);
  }
}
