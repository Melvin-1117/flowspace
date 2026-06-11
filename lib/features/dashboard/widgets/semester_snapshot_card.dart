import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../planner/providers/planner_providers.dart';
import 'shimmer/health_card_shimmer.dart';

class SemesterSnapshotCard extends ConsumerWidget {
  const SemesterSnapshotCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(semesterHealthProvider);
    final subjectsAsync = ref.watch(allSubjectsProvider);

    return healthAsync.when(
      loading: () => const HealthCardShimmer(),
      error: (_, __) => const SizedBox.shrink(),
      data: (health) {
        final subjects = subjectsAsync.valueOrNull ?? [];

        if (subjects.isEmpty) {
          return _EmptySubjectsCard(onAdd: () => context.go('/planner'));
        }

        final topSubjects = [...subjects]
          ..sort(
              (a, b) => b.completionPercent.compareTo(a.completionPercent));
        final displaySubjects = topSubjects.take(2).toList();

        final statusLabel = health.score >= 70
            ? 'OPTIMAL'
            : health.score >= 40
                ? 'AT RISK'
                : 'CRITICAL';
        final statusColor = health.score >= 70
            ? AppTheme.success
            : health.score >= 40
                ? AppTheme.warning
                : AppTheme.danger;

        return GestureDetector(
          onTap: () => context.go('/planner'),
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
                      'SEMESTER HEALTH',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      'View Planner →',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Score ring + status
                Row(
                  children: [
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: (health.score / 100).clamp(0.0, 1.0),
                            strokeWidth: 5,
                            backgroundColor: AppTheme.surfaceBorder,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(statusColor),
                          ),
                          Text(
                            '${health.score.round()}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${subjects.length} subject${subjects.length == 1 ? '' : 's'} tracked',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),

                if (displaySubjects.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ...displaySubjects.map((subject) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  subject.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${(subject.completionPercent * 100).round()}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: subject.completionPercent,
                              minHeight: 4,
                              backgroundColor: AppTheme.surfaceBorder,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptySubjectsCard extends StatelessWidget {
  const _EmptySubjectsCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.school_rounded,
              color: AppTheme.textMuted, size: 32),
          const SizedBox(height: 12),
          Text(
            'Add subjects to track your progress',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Subject'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}
