import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';

/// Inline card displaying the currently linked task, or a prompt to link one.
/// Replaces the old FAB approach.
class LinkedTaskCard extends ConsumerWidget {
  const LinkedTaskCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerNotifierProvider);
    final hasTask = timerState.linkedTaskTitle != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasTask
                ? AppTheme.primary.withValues(alpha: 0.4)
                : AppTheme.surfaceBorder,
          ),
        ),
        child: Row(
          children: [
            // Task icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasTask
                    ? AppTheme.primary.withValues(alpha: 0.15)
                    : AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                hasTask ? Icons.task_alt_rounded : Icons.add_task_rounded,
                color: hasTask ? AppTheme.primary : AppTheme.textMuted,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Task info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasTask ? 'LINKED TASK' : 'NO TASK LINKED',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasTask
                        ? timerState.linkedTaskTitle!
                        : 'Tap to link a task to this session',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: hasTask ? AppTheme.textPrimary : AppTheme.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
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
