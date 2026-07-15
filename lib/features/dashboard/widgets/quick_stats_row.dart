import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../providers/dashboard_providers.dart';

class QuickStatsRow extends ConsumerWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksDueToday = ref.watch(dashboardTasksDueTodayProvider);
    final streak = ref.watch(dashboardStreakProvider);
    final sessionsToday = ref.watch(dashboardSessionsTodayProvider);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            iconColor: tasksDueToday > 0
                ? AppTheme.primary
                : AppTheme.textSecondary,
            value: '$tasksDueToday',
            label: 'Due Today',
            onTap: () => context.go('/tasks'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: streak > 0 ? AppTheme.warning : AppTheme.textSecondary,
            value: '$streak',
            label: 'Day Streak',
            onTap: () => context.go('/analytics'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.timer_rounded,
            iconColor: AppTheme.accent,
            value: '$sessionsToday',
            label: 'Sessions',
            onTap: () => context.go('/pomodoro'),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
