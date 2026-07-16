import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';

/// Full-screen overlay shown when 3 strikes are reached.
/// Session is NOT saved to Isar. Shows failure summary.
class SessionVoidOverlay extends StatelessWidget {
  const SessionVoidOverlay({
    required this.durationAttempted,
    required this.timeCompletedSeconds,
    super.key,
  });

  final int durationAttempted;
  final int timeCompletedSeconds;

  String _formatElapsed(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    if (m == 0) return '${s}s';
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Void icon
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.danger.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppTheme.danger.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppTheme.danger,
                  size: 52,
                ),
              )
                  .animate()
                  .scaleXY(
                    begin: 0.5,
                    end: 1.0,
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 28),

              Text(
                'Session Void',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.danger,
                  letterSpacing: -0.8,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '3 strikes reached — this session\nwill not be counted.',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: Column(
                  children: [
                    _VoidStatRow(
                      label: 'Session target',
                      value: '${durationAttempted}m',
                      color: AppTheme.textSecondary,
                    ),
                    const Divider(color: AppTheme.surfaceBorder, height: 20),
                    _VoidStatRow(
                      label: 'Time completed',
                      value: _formatElapsed(timeCompletedSeconds),
                      color: AppTheme.primary,
                    ),
                    const Divider(color: AppTheme.surfaceBorder, height: 20),
                    _VoidStatRow(
                      label: 'Strikes received',
                      value: '3 of 3',
                      color: AppTheme.danger,
                    ),
                    const Divider(color: AppTheme.surfaceBorder, height: 20),
                    _VoidStatRow(
                      label: 'Session status',
                      value: 'NOT SAVED',
                      color: AppTheme.danger,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                '"Every attempt builds discipline.\nTry again." 💪',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Try again button
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
                    'Try Again',
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

class _VoidStatRow extends StatelessWidget {
  const _VoidStatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
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
