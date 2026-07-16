import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../pomodoro/providers/pomodoro_providers.dart';
import 'quick_note_sheet.dart';

class QuickActionSheet extends ConsumerWidget {
  const QuickActionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.surfaceBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),

          _QuickActionTile(
            icon: Icons.check_circle_outline_rounded,
            label: 'Add Task',
            color: AppTheme.primary,
            onTap: () {
              Navigator.pop(context);
              context.go('/tasks');
            },
          ),
          const SizedBox(height: 8),

          _QuickActionTile(
            icon: Icons.timer_rounded,
            label: 'Start Focus',
            color: AppTheme.accent,
            onTap: () {
              Navigator.pop(context);
              ref.read(timerNotifierProvider.notifier).start();
              context.go('/pomodoro');
            },
          ),
          const SizedBox(height: 8),

          _QuickActionTile(
            icon: Icons.book_rounded,
            label: 'Add Journal Entry',
            color: AppTheme.accent,
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const QuickNoteSheet(),
              );
            },
          ),
          const SizedBox(height: 8),

          _QuickActionTile(
            icon: Icons.flag_rounded,
            label: 'Add Milestone',
            color: AppTheme.warning,
            onTap: () {
              Navigator.pop(context);
              context.go('/planner');
            },
          ),
          const SizedBox(height: 8),

          _QuickActionTile(
            icon: Icons.screen_lock_portrait_rounded,
            label: 'Focus Lock',
            color: AppTheme.primary,
            onTap: () {
              Navigator.pop(context);
              context.go('/focus-lock');
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
