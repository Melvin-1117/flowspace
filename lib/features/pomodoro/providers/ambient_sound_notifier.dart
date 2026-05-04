import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/focus_goal_settings.dart';
import '../../../core/providers/isar_provider.dart';
import '../../../core/services/audio_service.dart';
import 'pomodoro_web_store.dart';

class AmbientState {
  const AmbientState({this.selectedSound, required this.volume});

  final String? selectedSound;
  final double volume;

  String? get selected => selectedSound;
  bool get isPlaying => selectedSound != null;

  AmbientState copyWith({
    String? selectedSound,
    bool clearSelected = false,
    double? volume,
  }) {
    return AmbientState(
      selectedSound: clearSelected
          ? null
          : (selectedSound ?? this.selectedSound),
      volume: volume ?? this.volume,
    );
  }
}

class AmbientSoundNotifier extends StateNotifier<AmbientState> {
  AmbientSoundNotifier(this.ref)
    : _player = AudioService.instance.ambientPlayer,
      super(const AmbientState(selectedSound: null, volume: 0.4)) {
    _init();
  }

  final Ref ref;
  final AudioPlayer _player;

  Future<void> _init() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    final settings = await _readSettings();
    final selected = settings?.lastAmbientSound;
    final volume = settings?.ambientVolume ?? 0.4;
    state = state.copyWith(selectedSound: selected, volume: volume);
    await _player.setVolume(volume);
    if (selected != null) {
      await restoreSound(selected);
    }
  }

  Future<void> _persistAmbientState(String? soundName) async {
    final settings = await _readSettings();
    if (settings == null) return;
    settings.lastAmbientSound = soundName;
    await _writeSettings(settings);
  }

  Future<void> _persistAmbientVolume(double volume) async {
    final settings = await _readSettings();
    if (settings == null) return;
    settings.ambientVolume = volume;
    await _writeSettings(settings);
  }

  Future<void> selectOrToggle(String key) async {
    if (state.selectedSound == key) {
      await stop();
      return;
    }
    await restoreSound(key);
  }

  Future<void> restoreSound(String key) async {
    final asset = AudioService.ambientAssets[key];
    if (asset == null) return;
    await _player.play(AssetSource(asset), volume: state.volume);
    state = state.copyWith(selectedSound: key);
    await _persistAmbientState(key);
  }

  Future<void> resumeIfSelected() async {
    final key = state.selectedSound;
    if (key == null) return;
    await restoreSound(key);
  }

  Future<void> stop() async {
    await _player.stop();
    state = state.copyWith(clearSelected: true);
    await _persistAmbientState(null);
  }

  Future<void> setVolume(double value) async {
    await _player.setVolume(value);
    state = state.copyWith(volume: value);
    await _persistAmbientVolume(value);
  }

  Future<FocusGoalSettings?> _readSettings() async {
    if (kIsWeb) {
      return PomodoroWebStore.instance.ensureSettings();
    }
    final isar = await ref.read(isarProvider.future);
    return (isar as dynamic).focusGoalSettings.get(1) as FocusGoalSettings?;
  }

  Future<void> _writeSettings(FocusGoalSettings settings) async {
    if (kIsWeb) {
      PomodoroWebStore.instance.updateSettings(settings);
      return;
    }
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(
      () => (isar as dynamic).focusGoalSettings.put(settings),
    );
  }
}
