import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../providers/focus_lock_notifier.dart';

/// Celebration overlay shown when a Focus Lock session completes successfully.
/// Session IS saved to Isar. Shows stats + focus score.
class SessionCompleteOverlay extends StatelessWidget {
  const SessionCompleteOverlay({
    required this.durationMinutes,
    required this.strikes,
    super.key,
  });

  final int durationMinutes;
  final int strikes;

  @override
  Widget build(BuildContext context) {
    final scoreText = focusScoreLabel(durationMinutes, strikes);

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Trophy
              const Text('🏆', style: TextStyle(fontSize: 80))
                  .animate()
                  .scaleXY(
                    begin: 0.3,
                    end: 1.0,
                    duration: 700.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 24),

              Text(
                strikes == 0 ? 'Perfect Lock! 🎯' : 'Session Complete!',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.8,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                strikes == 0
                    ? 'Zero distractions — outstanding focus!'
                    : 'You pushed through. Great work!',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Stats card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    _CompleteStatRow(
                      icon: Icons.timer_rounded,
                      label: 'Time Focused',
                      value: '${durationMinutes}m',
                      color: AppTheme.primary,
                    ),
                    const Divider(color: AppTheme.surfaceBorder, height: 20),
                    _CompleteStatRow(
                      icon: Icons.warning_amber_rounded,
                      label: 'Strikes',
                      value: '$strikes of 3',
                      color:
                          strikes == 0 ? AppTheme.success : AppTheme.warning,
                    ),
                    const Divider(color: AppTheme.surfaceBorder, height: 20),
                    _CompleteStatRow(
                      icon: Icons.emoji_events_rounded,
                      label: 'Focus Score',
                      value: scoreText,
                      color: AppTheme.warning,
                    ),
                    const Divider(color: AppTheme.surfaceBorder, height: 20),
                    _CompleteStatRow(
                      icon: Icons.save_rounded,
                      label: 'Status',
                      value: 'SAVED',
                      color: AppTheme.success,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Start another session
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/focus-lock'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Start Another Session',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: Text(
                  'Go to Dashboard',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompleteStatRow extends StatelessWidget {
  const _CompleteStatRow({
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
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
