import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pomodoro_providers.dart';

class NowPlayingCard extends ConsumerWidget {
  const NowPlayingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicState = ref.watch(musicPlayerProvider);
    final notifier = ref.read(musicPlayerProvider.notifier);
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOW PLAYING',
            style: TextStyle(
              color: Color(0xFF555555),
              letterSpacing: 1.6,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF121733),
                      Color(0xFF7C3AED),
                      Color(0xFF06B6D4),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicState.currentTrack.title,
                      style: const TextStyle(
                        color: Color(0xFFF0F0F0),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      musicState.currentTrack.artist,
                      style: const TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () async {
                  HapticFeedback.selectionClick();
                  await notifier.previous();
                },
                icon: const Icon(
                  Icons.skip_previous_rounded,
                  color: Color(0xFFA0A0A5),
                ),
              ),
              InkWell(
                onTap: () => notifier.togglePlayback(),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7C3AED),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    musicState.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  HapticFeedback.selectionClick();
                  await notifier.next();
                },
                icon: const Icon(
                  Icons.skip_next_rounded,
                  color: Color(0xFFA0A0A5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _sectionCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0D0D0D),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0x1AFFFFFF)),
    ),
    child: child,
  );
}
