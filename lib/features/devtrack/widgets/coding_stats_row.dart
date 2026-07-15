import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../providers/devtrack_providers.dart';

/// 3-stat card row: Today's Coding, Total Hours, Streak.
class CodingStatsRow extends ConsumerWidget {
  const CodingStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAsync = ref.watch(todayCodingSessionsProvider);
    final totalAsync = ref.watch(totalCodingHoursProvider);
    final streakAsync = ref.watch(codingStreakProvider);

    final todayMinutes =
        todayAsync.valueOrNull?.fold(0, (s, e) => s + e.durationMinutes) ?? 0;
    final totalHours = totalAsync.valueOrNull ?? 0.0;
    final streak = streakAsync.valueOrNull ?? 0;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.code_rounded,
            iconColor: AppTheme.primary,
            value: formatDurationMinutes(todayMinutes * 60),
            label: 'Coded Today',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.laptop_rounded,
            iconColor: AppTheme.accent,
            value: '${totalHours.toStringAsFixed(0)}h',
            label: 'Total Hours',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppTheme.warning,
            value: '$streak days',
            label: 'Streak',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 10),
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
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
