import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../analytics/providers/analytics_providers.dart';

class WeeklyVelocitySnapshot extends ConsumerWidget {
  const WeeklyVelocitySnapshot({super.key});

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final velocityAsync = ref.watch(weeklyVelocityProvider);
    final changeAsync = ref.watch(velocityChangeProvider);

    return velocityAsync.when(
      loading: () => const ShimmerBox.chart(),
      error: (_, __) => const SizedBox.shrink(),
      data: (velocity) {
        final change = changeAsync.valueOrNull ?? double.nan;
        final maxMinutes = velocity.fold<int>(
            0, (m, d) => d.totalMinutes > m ? d.totalMinutes : m);
        final totalMinutes =
            velocity.fold<int>(0, (sum, d) => sum + d.totalMinutes);
        final hours = totalMinutes ~/ 60;
        final mins = totalMinutes % 60;

        return GestureDetector(
          onTap: () => context.go('/analytics'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'THIS WEEK',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    if (!change.isNaN)
                      _ChangeBadge(changePercent: change),
                  ],
                ),
                const SizedBox(height: 16),

                // Bar chart
                SizedBox(
                  height: 72,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (i) {
                      final day = i < velocity.length ? velocity[i] : null;
                      final minutes = day?.totalMinutes ?? 0;
                      final isToday = day?.isToday ?? false;
                      final barHeight = maxMinutes > 0
                          ? (minutes / maxMinutes * 64).clamp(4.0, 64.0)
                          : 4.0;
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              height: barHeight,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: isToday
                                    ? AppTheme.primary
                                    : AppTheme.surfaceBorder,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _dayLabels[i],
                              style: TextStyle(
                                color: isToday
                                    ? AppTheme.primary
                                    : AppTheme.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 14),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${hours}h ${mins}m total focus',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    Text(
                      'View Analytics →',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.changePercent});

  final double changePercent;

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent >= 0;
    final color = isPositive ? AppTheme.success : AppTheme.danger;
    final sign = isPositive ? '+' : '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$sign${changePercent.round()}%',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
