import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/focus_block.dart';
import '../../../app/theme.dart';

class FocusBlockItem extends StatelessWidget {
  const FocusBlockItem({
    required this.block,
    required this.onOpenDetails,
    required this.onOpenMenu,
    super.key,
  });

  final FocusBlock block;
  final VoidCallback onOpenDetails;
  final VoidCallback onOpenMenu;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isMissed = !block.isCompleted && block.scheduledTime.isBefore(now);

    return InkWell(
      onTap: onOpenDetails,
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: block.isCompleted ? 0.6 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  isMissed
                      ? 'MISSED'
                      : DateFormat('HH:mm').format(block.scheduledTime),
                  style: TextStyle(
                    color: isMissed
                        ? AppTheme.danger
                        : (block.isCompleted
                              ? AppTheme.textSecondary
                              : AppTheme.textPrimary),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      block.title,
                      style: TextStyle(
                        color: block.isCompleted
                            ? AppTheme.textSecondary
                            : AppTheme.textPrimary,
                        decoration: block.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_sessionLabel(block.sessionType)} • ${block.durationMinutes} mins',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onOpenMenu,
                icon: Icon(
                  block.isCompleted ? Icons.check_circle : Icons.more_vert,
                  color: block.isCompleted
                      ? AppTheme.success
                      : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _sessionLabel(String key) {
  return switch (key) {
    'deepwork' => 'Deep Work',
    'review' => 'Review',
    'practice' => 'Practice',
    'reading' => 'Reading',
    _ => 'Focus',
  };
}
