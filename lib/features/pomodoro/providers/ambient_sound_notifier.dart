import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmbientState {
  const AmbientState({
    this.selected,
    this.volume = 0.4,
    this.isPlaying = false,
  });

  final String? selected;
  final double volume;
  final bool isPlaying;

  AmbientState copyWith({
    String? selected,
    double? volume,
    bool? isPlaying,
  }) {
    return AmbientState(
      selected: selected ?? this.selected,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class AmbientSoundNotifier extends StateNotifier<AmbientState> {
  AmbientSoundNotifier() : super(const AmbientState());

  void setSound(String? sound) {
    state = state.copyWith(
      selected: sound,
      isPlaying: sound != null,
    );
  }

  void setVolume(double volume) {
    state = state.copyWith(volume: volume.clamp(0.0, 1.0));
  }

  void togglePlayPause() {
    if (state.selected != null) {
      state = state.copyWith(isPlaying: !state.isPlaying);
    }
  }

  void stop() {
    state = state.copyWith(
      isPlaying: false,
      selected: null,
    );
  }
}
