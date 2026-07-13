import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/pomodoro_providers.dart';
import '../../analytics/analytics_payload.dart';
import '../../../app/theme.dart';

class SessionHistoryCard extends ConsumerWidget {
  const SessionHistoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(todaySessionsProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SESSION HISTORY',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                sessionsAsync.when(
                  data: (sessions) => sessions.isEmpty
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            final todaySessions =
                                ref.read(todaySessionsProvider).value ?? [];
                            final payload = AnalyticsPayload(
                              sourceScreen: 'pomodoro',
                              focusDate: DateTime.now(),
                              totalFocusMinutes: todaySessions
                                  .where((s) => s.sessionType == 'focus' && s.isCompleted)
                                  .fold(
                                    0,
                                    (sum, s) => sum + (s.actualDurationSeconds ~/ 60),
                                  ),
                              completedSessions: todaySessions
                                  .where((s) => s.isCompleted)
                                  .length,
                              abandonedSessions: todaySessions
                                  .where((s) => s.isAbandoned)
                                  .length,
                              linkedTaskIds: todaySessions
                                  .where((s) => s.linkedTaskId != null)
                                  .map((s) => s.linkedTaskId!)
                                  .toSet()
                                  .toList(),
                            );
                            context.push('/analytics', extra: payload);
                          },
                          child: Text(
                            'VIEW ALL →',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const Divider(color: AppTheme.surfaceBorder, height: 1),

          // Session list
          sessionsAsync.when(
            data: (sessions) {
              final displayed = sessions.take(3).toList();

              if (displayed.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.history_rounded,
                        color: AppTheme.textMuted,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No sessions yet today',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Start your first focus session!',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayed.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: AppTheme.surfaceBorder, height: 1),
                itemBuilder: (_, i) {
                  return _SessionHistoryRow(session: displayed[i]);
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Could not load history',
                style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionHistoryRow extends StatelessWidget {
  const _SessionHistoryRow({required this.session});

  final dynamic session;

  @override
  Widget build(BuildContext context) {
    final isAbandoned = session.isAbandoned;
    final isFocus = session.sessionType == 'focus';

    final barColor = isAbandoned
        ? const Color(0xFF1A2640)
        : isFocus
            ? const Color(0xFF006EE6)
            : session.sessionType == 'shortbreak'
                ? const Color(0xFF00B4FF)
                : const Color(0xFF00D4AA);

    final start = DateFormat('h:mm a').format(session.startTime);
    final effectiveEnd = session.endTime ??
        session.startTime.add(Duration(seconds: session.actualDurationSeconds));
    final end = DateFormat('h:mm a').format(effectiveEnd);
    final durationMinutes = (session.actualDurationSeconds / 60).round();

    final title = (session.linkedTaskTitle == null || session.linkedTaskTitle!.isEmpty)
        ? (isFocus
            ? 'Focus Session'
            : session.sessionType == 'shortbreak'
                ? 'Short Break'
                : 'Long Break')
        : session.linkedTaskTitle!;

    return Opacity(
      opacity: isAbandoned ? 0.6 : 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Colored bar
            Container(
              width: 3,
              height: 40,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: 12),

            // Session info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isAbandoned ? AppTheme.textSecondary : AppTheme.textPrimary,
                      fontStyle: isAbandoned ? FontStyle.italic : FontStyle.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$start — $end',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Duration badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: barColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: barColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                '$durationMinutes MIN',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: barColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
