import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/pomodoro_providers.dart';
import 'timer_ring_painter.dart';
import '../../../app/theme.dart';

class TimerRing extends ConsumerStatefulWidget {
  const TimerRing({super.key});

  @override
  ConsumerState<TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends ConsumerState<TimerRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerNotifierProvider);
    final sessionType = timerState.sessionType;
    final sessionColor = sessionType.color;

    // Render smooth decay between one-second state commits.
    final drift = timerState.isRunning
        ? DateTime.now().difference(timerState.lastTickAt).inMilliseconds / 1000
        : 0.0;
    // Ensure remaining seconds is valid before applying drift
    final validRemaining = timerState.remainingSeconds < 0
        ? 0
        : timerState.remainingSeconds;
    final smoothRemaining = math.max(0.0, validRemaining - drift);
    final smoothProgress = timerState.totalDurationSeconds <= 0
        ? 0.0
        : (smoothRemaining / timerState.totalDurationSeconds).clamp(0.0, 1.0);

    if (timerState.isRunning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!timerState.isRunning && _controller.isAnimating) {
      _controller.stop();
    }

    final minutes = (smoothRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (smoothRemaining.toInt() % 60).toString().padLeft(2, '0');
    final formattedTime = '$minutes:$seconds';
    final progressPercent = (smoothProgress * 100).round();

    final sessionCount = ref.watch(sessionCountProvider);
    final settings = ref.watch(focusGoalSettingsProvider).value;
    final longBreakInterval = settings?.longBreakInterval ?? 4;

    return RepaintBoundary(
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: sessionColor.withValues(alpha: 0.12),
              blurRadius: 60,
              spreadRadius: 20,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background track and progress ring in one painter
            CustomPaint(
              size: const Size(260, 260),
              painter: TimerRingPainter(
                progress: smoothProgress,
                sessionColor: sessionColor,
                strokeWidth: 8,
              ),
            ),

            // Center content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Session type label
                Text(
                  sessionType.label.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Countdown time digits
                Text(
                  formattedTime,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),

                // Progress percentage label
                Text(
                  '$progressPercent%',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Session counter pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: sessionColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: sessionColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    'Session $sessionCount of $longBreakInterval',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: sessionColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
