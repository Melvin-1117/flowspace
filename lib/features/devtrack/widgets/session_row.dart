import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../../core/utils/formatters.dart';
import '../models/coding_session.dart';
import '../models/dev_project.dart';

class SessionRow extends StatelessWidget {
  final CodingSession session;
  final DevProject? project;

  const SessionRow({
    super.key,
    required this.session,
    this.project,
  });

  IconData _getSessionIcon(String type) {
    return switch (type.toLowerCase()) {
      'bugfix' => Icons.bug_report_outlined,
      'learning' => Icons.school_outlined,
      'review' => Icons.rate_review_outlined,
      _ => Icons.code_rounded,
    };
  }

  Color _getSessionColor(String type) {
    return switch (type.toLowerCase()) {
      'bugfix' => AppTheme.danger,
      'learning' => AppTheme.warning,
      'review' => AppTheme.success,
      _ => AppTheme.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final sessionColor = _getSessionColor(session.sessionType);
    final sessionIcon = _getSessionIcon(session.sessionType);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: sessionColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: sessionColor.withOpacity(0.3)),
            ),
            child: Icon(sessionIcon, color: sessionColor, size: 18),
          ),
          const SizedBox(width: AppTheme.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      project?.name ?? session.language,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${session.durationMinutes} min',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${session.language} • ${session.sessionType.toUpperCase()}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      formatRelativeTime(session.startTime),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                if (session.notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    session.notes,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
