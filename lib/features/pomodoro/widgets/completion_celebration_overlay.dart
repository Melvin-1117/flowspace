import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';
import '../services/alarm_service.dart';

/// Full-screen celebration overlay shown for 3 seconds after a session
/// completes, before the alarm overlay appears.
class CompletionCelebrationOverlay extends ConsumerStatefulWidget {
  const CompletionCelebrationOverlay({super.key});

  @override
  ConsumerState<CompletionCelebrationOverlay> createState() =>
      _CompletionCelebrationState();
}

class _CompletionCelebrationState
    extends ConsumerState<CompletionCelebrationOverlay> {
  @override
  void initState() {
    super.initState();
    // Auto transition to alarm overlay after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        ref.read(showCompletionCelebrationProvider.notifier).state = false;
        ref.read(alarmServiceProvider).startAlarm();
        ref.read(alarmOverlayVisibleProvider.notifier).state = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trialsUsed = ref.watch(
      timerNotifierProvider.select((s) => s.trialsUsed),
    );
    final sessionCount = ref.watch(sessionCountProvider);
    final completionOverlay = ref.watch(
      timerNotifierProvider.select((s) => s.completionOverlay),
    );
    final perfectSession = trialsUsed == 0;
    final actualMinutes =
        completionOverlay != null
            ? (completionOverlay.actualDurationSeconds / 60).round()
            : 25;

    return Positioned.fill(
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated checkmark
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.success.withValues(alpha: 0.15),
                  border: Border.all(color: AppTheme.success, width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppTheme.success,
                  size: 56,
                ),
              )
                  .animate()
                  .scaleXY(
                    begin: 0.5,
                    end: 1.0,
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 32),

              Text(
                perfectSession ? 'Perfect Session! 🎯' : 'Session Complete!',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.8,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: 12),

              Text(
                'Session $sessionCount complete',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // Mini stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CelebrationStat(
                    icon: Icons.timer_rounded,
                    label: 'Focus Time',
                    value: '${actualMinutes}m',
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 24),
                  _CelebrationStat(
                    icon: Icons.pause_circle_outline_rounded,
                    label: 'Pauses Used',
                    value: '$trialsUsed of 3',
                    color: trialsUsed == 0 ? AppTheme.success : AppTheme.warning,
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

              const SizedBox(height: 48),

              // Transition hint
              Text(
                'Break starting in 3 seconds...',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _CelebrationStat extends StatelessWidget {
  const _CelebrationStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
