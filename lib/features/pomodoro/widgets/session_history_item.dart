import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/pomodoro_session.dart';
import '../../../app/theme.dart';

class SessionHistoryItem extends StatelessWidget {
  const SessionHistoryItem({super.key, required this.session});

  final PomodoroSession session;

  @override
  Widget build(BuildContext context) {
    final barColor = this.barColor;
    final textColor = session.isAbandoned
        ? AppTheme.textSecondary
        : AppTheme.textPrimary;

    final start = DateFormat('h:mm a').format(session.startTime);
    final effectiveEnd =
        session.endTime ??
        session.startTime.add(Duration(seconds: session.actualDurationSeconds));
    final end = DateFormat('h:mm a').format(effectiveEnd);
    final durationMinutes = (session.actualDurationSeconds / 60).round();
    final title =
        (session.linkedTaskTitle == null || session.linkedTaskTitle!.isEmpty)
        ? (session.sessionType == 'focus' ? 'Focus Session' : 'Break Session')
        : session.linkedTaskTitle!;

    return Opacity(
      opacity: itemOpacity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              Text(
                '$start - $end',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$durationMinutes MIN',
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get barColor {
    if (session.isAbandoned) return AppTheme.surfaceBorder;
    if (session.sessionType == 'focus') return AppTheme.primary;
    return AppTheme.accent;
  }

  double get itemOpacity => session.isAbandoned ? 0.6 : 1.0;
  bool get isItalic => session.isAbandoned;
}
