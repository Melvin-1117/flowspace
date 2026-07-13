import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';

/// Row of 3 mini stat cards: today's focus time, streak, sessions completed.
class FocusStatsRow extends ConsumerWidget {
  const FocusStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Today's Focus Time
          Expanded(
            child: _StatMiniCard(
              icon: Icons.timer_outlined,
              label: 'Today',
              value: ref.watch(todayFocusMinutesProvider).when(
                    data: (mins) => _formatMinutes(mins),
                    loading: () => '--',
                    error: (_, __) => '--',
                  ),
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 8),

          // Current Streak
          Expanded(
            child: _StatMiniCard(
              icon: Icons.local_fire_department_rounded,
              label: 'Streak',
              value: ref.watch(goalStreakProvider).when(
                    data: (days) => '${days}d',
                    loading: () => '--',
                    error: (_, __) => '--',
                  ),
              color: AppTheme.warning,
            ),
          ),
          const SizedBox(width: 8),

          // Sessions Completed Today
          Expanded(
            child: _StatMiniCard(
              icon: Icons.check_circle_outline_rounded,
              label: 'Sessions',
              value: ref.watch(todaySessionsProvider).when(
                    data: (sessions) => sessions
                        .where(
                            (s) => s.isCompleted && s.sessionType == 'focus')
                        .length
                        .toString(),
                    loading: () => '--',
                    error: (_, __) => '--',
                  ),
              color: AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMinutes(int totalMinutes) {
    if (totalMinutes < 60) return '${totalMinutes}m';
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}

class _StatMiniCard extends StatelessWidget {
  const _StatMiniCard({
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
