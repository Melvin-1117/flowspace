import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../tasks/providers/task_providers.dart';
import 'shimmer/task_summary_shimmer.dart';

class TaskSummaryCard extends ConsumerWidget {
  const TaskSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(allTasksProvider);

    return tasksAsync.when(
      loading: () => const TaskSummaryShimmer(),
      error: (_, __) => const SizedBox.shrink(),
      data: (allTasks) {
        if (allTasks.isEmpty) {
          return _EmptyTaskCard(onAdd: () => context.go('/tasks'));
        }

        final todo = allTasks.where((t) => t.status == 'todo').length;
        final inProgress =
            allTasks.where((t) => t.status == 'inprogress').length;
        final done = allTasks.where((t) => t.status == 'done').length;
        final overdue = allTasks
            .where((t) =>
                t.dueDate != null &&
                t.dueDate!.isBefore(DateTime.now()) &&
                t.status != 'done')
            .length;
        final total = allTasks.length;
        final progress = total == 0 ? 0.0 : done / total;

        return GestureDetector(
          onTap: () => context.go('/tasks'),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(
                color: overdue > 0 ? AppTheme.danger : AppTheme.surfaceBorder,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TASKS',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      'View All →',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppTheme.surfaceBorder,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 14),

                // Stat chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusChip(
                      label: 'To Do',
                      count: todo,
                      color: AppTheme.textSecondary,
                    ),
                    _StatusChip(
                      label: 'In Progress',
                      count: inProgress,
                      color: AppTheme.primary,
                    ),
                    _StatusChip(
                      label: 'Done',
                      count: done,
                      color: AppTheme.success,
                    ),
                    if (overdue > 0)
                      _StatusChip(
                        label: 'Overdue',
                        count: overdue,
                        color: AppTheme.danger,
                      ),
                  ],
                ),

                // Overdue warning
                if (overdue > 0) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.warning_rounded,
                          color: AppTheme.danger, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '$overdue task${overdue > 1 ? 's' : ''} overdue',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.danger,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTaskCard extends StatelessWidget {
  const _EmptyTaskCard({required this.onAdd});

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
          const Icon(Icons.check_circle_outline_rounded,
              color: AppTheme.textMuted, size: 32),
          const SizedBox(height: 12),
          Text(
            'No tasks yet — add your first task',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Task'),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}
