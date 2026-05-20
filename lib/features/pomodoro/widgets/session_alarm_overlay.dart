import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';
import '../services/alarm_service.dart';

/// Full-screen alarm overlay displayed when a session completes.
/// Shows session count, a perfect-session badge when no pauses were used,
/// and buttons to start break / skip break / dismiss alarm.
class SessionAlarmOverlay extends ConsumerWidget {
  const SessionAlarmOverlay({
    required this.sessionNumber,
    required this.isLastBeforeLong,
    super.key,
  });

  final int sessionNumber;
  final bool isLastBeforeLong;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trialsUsed = ref.watch(
      timerNotifierProvider.select((s) => s.trialsUsed),
    );
    final perfectSession = trialsUsed == 0;
    final settings = ref.watch(focusGoalSettingsProvider).value;
    final longBreakInterval = settings?.longBreakInterval ?? 4;

    return Positioned.fill(
      child: Container(
        color: Colors.black,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pulsing alarm icon
                _PulsingAlarmIcon(),

                const SizedBox(height: 32),

                // Session complete heading
                Text(
                  'Session Complete!',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.8,
                  ),
                ),

                const SizedBox(height: 12),

                // Session number
                Text(
                  'Focus Session $sessionNumber of $longBreakInterval',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                // Perfect / pauses used badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: perfectSession
                        ? AppTheme.success.withValues(alpha: 0.15)
                        : AppTheme.surfaceBorder,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: perfectSession
                          ? AppTheme.success
                          : AppTheme.surfaceBorder,
                    ),
                  ),
                  child: Text(
                    perfectSession
                        ? '🎯  Perfect session — no pauses!'
                        : '⏸  $trialsUsed pause${trialsUsed > 1 ? 's' : ''} used',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: perfectSession
                          ? AppTheme.success
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Next session hint
                Text(
                  isLastBeforeLong
                      ? 'Time for a long break! 🎉'
                      : 'Time for a short break ☕',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: AppTheme.accent,
                  ),
                ),

                const SizedBox(height: 24),

                // Start Break button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(alarmServiceProvider).dismissAlarm();
                      ref
                          .read(timerNotifierProvider.notifier)
                          .startSuggestedBreak();
                      ref.read(alarmOverlayVisibleProvider.notifier).state =
                          false;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      isLastBeforeLong
                          ? 'Start Long Break'
                          : 'Start Short Break',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Skip Break button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(alarmServiceProvider).dismissAlarm();
                      ref
                          .read(timerNotifierProvider.notifier)
                          .skipBreakAndFocus();
                      ref.read(alarmOverlayVisibleProvider.notifier).state =
                          false;
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      side: const BorderSide(color: AppTheme.surfaceBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Skip Break',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Dismiss alarm only
                TextButton(
                  onPressed: () {
                    ref.read(alarmServiceProvider).dismissAlarm();
                    // Overlay stays — user chooses next action manually
                  },
                  child: Text(
                    'Dismiss Alarm',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Pulsing alarm icon ──────────────────────────────────────────────────
class _PulsingAlarmIcon extends StatefulWidget {
  @override
  State<_PulsingAlarmIcon> createState() => _PulsingAlarmIconState();
}

class _PulsingAlarmIconState extends State<_PulsingAlarmIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnim.value, child: child);
      },
      child: const Icon(
        Icons.alarm_rounded,
        color: AppTheme.primary,
        size: 80,
      ),
    );
  }
}
