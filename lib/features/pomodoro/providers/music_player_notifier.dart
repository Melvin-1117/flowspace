import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicState {
  const MusicState({
    this.currentTrackName,
    this.isPlaying = false,
    this.volume = 0.8,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  final String? currentTrackName;
  final bool isPlaying;
  final double volume;
  final Duration position;
  final Duration duration;

  MusicState copyWith({
    String? currentTrackName,
    bool? isPlaying,
    double? volume,
    Duration? position,
    Duration? duration,
  }) {
    return MusicState(
      currentTrackName: currentTrackName ?? this.currentTrackName,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

class MusicPlayerNotifier extends StateNotifier<MusicState> {
  MusicPlayerNotifier() : super(const MusicState());

  void play() {
    state = state.copyWith(isPlaying: true);
  }

  void pause() {
    state = state.copyWith(isPlaying: false);
  }

  void stop() {
    state = state.copyWith(
      isPlaying: false,
      position: Duration.zero,
      currentTrackName: null,
    );
  }

  void setTrack(String trackName) {
    state = state.copyWith(
      currentTrackName: trackName,
      position: Duration.zero,
    );
  }

  void setVolume(double volume) {
    state = state.copyWith(volume: volume.clamp(0.0, 1.0));
  }

  void setPosition(Duration position) {
    state = state.copyWith(position: position);
  }

  void setDuration(Duration duration) {
    state = state.copyWith(duration: duration);
  }
}
