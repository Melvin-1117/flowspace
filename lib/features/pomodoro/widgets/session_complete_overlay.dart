import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pomodoro_providers.dart';

class SessionCompleteOverlay extends ConsumerWidget {
  const SessionCompleteOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerNotifierProvider);
    final overlay = state.completionOverlay;
    if (overlay == null) return const SizedBox.shrink();
    final notifier = ref.read(timerNotifierProvider.notifier);
    final minutes = (overlay.actualDurationSeconds / 60).round();
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.75),
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x1AFFFFFF)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Session Complete!',
                style: TextStyle(
                  color: Color(0xFFF0F0F0),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${overlay.sessionType.label} • $minutes min',
                style: const TextStyle(color: Color(0xFF555555)),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: notifier.startSuggestedBreak,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                      ),
                      child: const Text('Start Break'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: notifier.skipBreakAndFocus,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFF0F0F0),
                        side: const BorderSide(color: Color(0x1EFFFFFF)),
                      ),
                      child: const Text('Skip Break'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
