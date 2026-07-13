import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/pomodoro_providers.dart';
import '../../../app/theme.dart';

class TimerControls extends ConsumerWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerNotifierProvider);
    final sessionColor = timerState.sessionType.color;
    final isLocked = timerState.sessionType == SessionType.focus &&
        timerState.trialsRemaining <= 0 &&
        timerState.isRunning;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Skip Back Button (Restart) ──────────────────────────
        _ControlButton(
          icon: Icons.skip_previous_rounded,
          size: 48,
          backgroundColor: AppTheme.surfaceCard,
          iconColor: AppTheme.textSecondary,
          borderColor: AppTheme.surfaceBorder,
          tooltip: 'Restart session',
          onTap: () {
            if (timerState.isRunning) {
              _showRestartConfirm(context, ref);
            } else {
              ref.read(timerNotifierProvider.notifier).reset();
            }
          },
        ),

        const SizedBox(width: 16),

        // ── Main Play/Pause Button ────────────────────
        GestureDetector(
          onTap: () {
            if (isLocked) {
              _showNoTrialsSnackbar(context);
              return;
            }
            if (timerState.isRunning) {
              ref.read(timerNotifierProvider.notifier).pause();
            } else {
              ref.read(timerNotifierProvider.notifier).start();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked ? AppTheme.dangerSubtle : sessionColor,
              boxShadow: [
                BoxShadow(
                  color: (isLocked ? AppTheme.danger : sessionColor)
                      .withValues(alpha: 0.4),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(
              isLocked
                  ? Icons.lock_rounded
                  : timerState.isRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32,
            ),
          )
              .animate(target: timerState.isRunning ? 1 : 0)
              .scaleXY(
                begin: 1.0,
                end: 0.95,
                duration: 100.ms,
              ),
        ),

        const SizedBox(width: 16),

        // ── Skip Forward Button (Skip to next) ───────────────────────
        _ControlButton(
          icon: Icons.skip_next_rounded,
          size: 48,
          backgroundColor: AppTheme.surfaceCard,
          iconColor: AppTheme.textSecondary,
          borderColor: AppTheme.surfaceBorder,
          tooltip: 'Skip to next session',
          onTap: () => _onSkipNext(context, ref),
        ),
      ],
    );
  }

  void _showRestartConfirm(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.surfaceBorder),
        ),
        title: Text(
          'Restart Session?',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Current session progress will be reset to the beginning.',
          style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(timerNotifierProvider.notifier).reset();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSkipNext(BuildContext context, WidgetRef ref) async {
    final timerState = ref.read(timerNotifierProvider);
    if (timerState.isRunning) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppTheme.surfaceBorder),
          ),
          title: Text(
            'Skip Session?',
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'This session will be marked as incomplete.',
            style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('Skip'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }
    await ref.read(timerNotifierProvider.notifier).skipToNext();
  }

  void _showNoTrialsSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🔒  No pauses remaining — stay focused!',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 13,
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
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.size,
    required this.backgroundColor,
    required this.iconColor,
    required this.borderColor,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final Color borderColor;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        )
            .animate()
            .scaleXY(
              begin: 1.0,
              end: 0.94,
              duration: 100.ms,
            ),
      ),
    );
  }
}
