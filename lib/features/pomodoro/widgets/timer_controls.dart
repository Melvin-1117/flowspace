import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/animation_tokens.dart';
import '../providers/pomodoro_providers.dart';
import '../../../app/theme.dart';

class TimerControls extends ConsumerWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerNotifierProvider);
    final isRunning = timerState.isRunning;
    final notifier = ref.read(timerNotifierProvider.notifier);

    // Locked when running a focus session with 0 trials remaining
    final isLocked = timerState.sessionType == SessionType.focus &&
        timerState.trialsRemaining <= 0 &&
        isRunning;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ScaleTapButton(
          onTap: () async {
            if (isLocked) {
              // Show snackbar — do NOT pause
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '🔒  No pauses remaining — stay focused!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily:
                          Theme.of(context).textTheme.bodyMedium?.fontFamily,
                    ),
                  ),
                  backgroundColor: AppTheme.danger,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              return;
            }
            if (isRunning) {
              await notifier.pause();
            } else {
              await notifier.start();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isLocked ? AppTheme.dangerSubtle : AppTheme.primary,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: (isLocked ? AppTheme.danger : AppTheme.primary)
                      .withValues(alpha: 0.35),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Icon(
              isLocked
                  ? Icons.lock_rounded
                  : (isRunning ? Icons.pause : Icons.play_arrow),
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _ScaleTapButton(
          onTap: () async {
            if (isRunning) {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppTheme.surfaceCard,
                  title: const Text('Reset timer?'),
                  content: const Text('Current progress will be lost.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;
            }
            await notifier.reset();
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: const Icon(
              Icons.refresh,
              color: AppTheme.textPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScaleTapButton extends StatefulWidget {
  const _ScaleTapButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_ScaleTapButton> createState() => _ScaleTapButtonState();
}

class _ScaleTapButtonState extends State<_ScaleTapButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: kMicroDuration,
        curve: kMicroCurve,
        child: widget.child,
      ),
    );
  }
}
