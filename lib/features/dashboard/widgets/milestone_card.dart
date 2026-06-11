import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../planner/providers/planner_providers.dart';
import 'shimmer/milestone_card_shimmer.dart';
import 'no_milestone_card.dart';

class MilestoneCard extends ConsumerWidget {
  const MilestoneCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final milestoneAsync = ref.watch(nextMilestoneProvider);
    final countdownAsync = ref.watch(milestoneCountdownProvider);

    return milestoneAsync.when(
      loading: () => const MilestoneCardShimmer(),
      error: (_, __) => const SizedBox.shrink(),
      data: (milestone) {
        if (milestone == null) {
          return NoMilestoneCard(onAdd: () => context.go('/planner'));
        }

        final countdown = countdownAsync.valueOrNull ?? Duration.zero;
        final days = countdown.inDays;
        final hours = countdown.inHours % 24;
        final mins = countdown.inMinutes % 60;

        final priorityColor = _priorityColor(milestone.priority);

        return GestureDetector(
          onTap: () => context.go('/planner'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(color: priorityColor.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  'NEXT CRITICAL MILESTONE',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 10),

                // Title + priority badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        milestone.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        milestone.priority.toUpperCase(),
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Countdown boxes
                Row(
                  children: [
                    _CountdownBox(value: '$days', label: 'DAYS'),
                    const SizedBox(width: 8),
                    _CountdownBox(value: '$hours', label: 'HRS'),
                    const SizedBox(width: 8),
                    _CountdownBox(value: '$mins', label: 'MIN'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _priorityColor(String priority) {
    return switch (priority.toLowerCase()) {
      'critical' => AppTheme.danger,
      'high' => AppTheme.warning,
      'medium' => AppTheme.primary,
      _ => AppTheme.textSecondary,
    };
  }
}

class _CountdownBox extends StatelessWidget {
  const _CountdownBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
