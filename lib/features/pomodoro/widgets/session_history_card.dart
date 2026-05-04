import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/pomodoro_providers.dart';
import '../../analytics/analytics_payload.dart';
import 'session_history_item.dart';

class SessionHistoryCard extends ConsumerWidget {
  const SessionHistoryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(todaySessionsProvider);
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SESSION HISTORY',
            style: TextStyle(
              color: Color(0xFF555555),
              letterSpacing: 1.6,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          sessionsAsync.when(
            data: (sessions) {
              final visible = sessions.take(3).toList();
              if (visible.isEmpty) {
                return const Text(
                  'No sessions yet today.',
                  style: TextStyle(color: Color(0xFF555555)),
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < visible.length; i++) ...[
                    SessionHistoryItem(session: visible[i])
                        .animate()
                        .slideX(
                          begin: 0.08,
                          end: 0,
                          duration: (220 + i * 50).ms,
                        )
                        .fade(duration: (220 + i * 50).ms),
                    if (i != visible.length - 1) const SizedBox(height: 10),
                  ],
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text(
              'Could not load history',
              style: TextStyle(color: Color(0xFF555555)),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
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
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFFB2B2B7),
                backgroundColor: const Color(0xFF141414),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'VIEW ANALYTICS',
                style: TextStyle(letterSpacing: 1.2, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sectionCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0D0D0D),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0x1AFFFFFF)),
    ),
    child: child,
  );
}
