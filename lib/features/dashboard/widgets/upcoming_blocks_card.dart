import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/models/focus_block.dart';
import '../../planner/providers/planner_providers.dart';
import '../../pomodoro/providers/pomodoro_providers.dart';

class UpcomingBlocksCard extends ConsumerWidget {
  const UpcomingBlocksCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(todayFocusBlocksProvider);

    return blocksAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (blocks) {
        final now = DateTime.now();
        final upcoming = blocks
            .where((b) => !b.isCompleted && b.scheduledTime.isAfter(now))
            .toList()
          ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

        if (upcoming.isEmpty) return const SizedBox.shrink();

        final display = upcoming.take(2).toList();

        return Container(
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
                    'UPCOMING FOCUS BLOCKS',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.go('/planner'),
                    child: Text(
                      'View All â†’',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Block rows
              ...display.map((block) {
                return _BlockRow(
                  block: block,
                  onStart: () {
                    ref
                        .read(timerNotifierProvider.notifier)
                        .startFocusWithDuration(
                          durationSeconds: block.durationMinutes * 60,
                          linkedTaskId: block.uuid,
                          linkedTaskTitle: block.title,
                        );
                    context.go('/pomodoro');
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _BlockRow extends StatelessWidget {
  const _BlockRow({required this.block, required this.onStart});

  final FocusBlock block;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(block.scheduledTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 48,
            child: Text(
              time,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          // Title + duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${block.durationMinutes} min',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
          // Start button
          SizedBox(
            height: 32,
            child: TextButton(
              onPressed: onStart,
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                foregroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Start',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
