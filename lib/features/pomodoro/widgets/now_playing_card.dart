import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pomodoro_providers.dart';

class NowPlayingCard extends ConsumerWidget {
  const NowPlayingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicState = ref.watch(musicPlayerProvider);
    final ambientState = ref.watch(ambientSoundProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF13101A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (musicState.currentTrackName != null)
            _buildMusicPlayer(context, ref, musicState)
          else
            _buildAmbientPlayer(context, ref, ambientState),
        ],
      ),
    );
  }

  Widget _buildMusicPlayer(BuildContext context, WidgetRef ref, musicState) {
    final notifier = ref.read(musicPlayerProvider.notifier);
    
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    musicState.currentTrackName ?? 'No Track',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Focus Music',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: musicState.isPlaying ? notifier.pause : notifier.play,
              icon: Icon(
                musicState.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.3, // Mock progress
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmbientPlayer(BuildContext context, WidgetRef ref, ambientState) {
    final notifier = ref.read(ambientSoundProvider.notifier);
    
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ambientState.selected != null 
                    ? const Color(0xFF7C3AED) 
                    : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getAmbientIcon(ambientState.selected),
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ambientState.selected != null 
                        ? '${ambientState.selected!.toUpperCase()} Ambient'
                        : 'No Ambient Sound',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ambientState.selected != null 
                        ? 'Background sounds'
                        : 'Select ambient sound',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (ambientState.selected != null)
              IconButton(
                onPressed: () => notifier.setVolume(0.0),
                icon: const Icon(
                  Icons.stop,
                  color: Colors.white,
                  size: 24,
                ),
              ),
          ],
        ),
        if (ambientState.selected != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.volume_down,
                color: Colors.grey[400],
                size: 16,
              ),
              Expanded(
                child: Slider(
                  value: ambientState.volume,
                  onChanged: notifier.setVolume,
                  activeColor: const Color(0xFF7C3AED),
                  inactiveColor: const Color(0xFF2A2A2A),
                ),
              ),
              Icon(
                Icons.volume_up,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ],
      ],
    );
  }

  IconData _getAmbientIcon(String? sound) {
    switch (sound) {
      case 'rain':
        return Icons.water_drop;
      case 'ocean':
        return Icons.waves;
      case 'forest':
        return Icons.nature;
      case 'cafe':
        return Icons.coffee;
      default:
        return Icons.volume_up;
    }
  }
}
