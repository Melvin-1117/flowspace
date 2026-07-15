import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/error_card.dart';
import '../providers/devtrack_providers.dart';
import 'session_row.dart';

class RecentSessionsSection extends ConsumerWidget {
  const RecentSessionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(allCodingSessionsProvider);
    final projectsAsync = ref.watch(allProjectsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT SESSIONS',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppTheme.spaceSM),
        sessionsAsync.when(
          data: (sessions) {
            if (sessions.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceXL),
                decoration: AppTheme.cardDecoration,
                child: Center(
                  child: Text(
                    'No sessions logged yet.',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
              );
            }

            final recentSessions = sessions.take(5).toList();

            return projectsAsync.when(
              data: (projects) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentSessions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppTheme.spaceSM),
                  itemBuilder: (context, index) {
                    final session = recentSessions[index];
                    final project = projects
                        .where((p) => p.uuid == session.projectId)
                        .firstOrNull;
                    return SessionRow(session: session, project: project);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (err, stack) =>
                  const SizedBox.shrink(), // project load error, fallback to null project
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spaceLG),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ErrorCard(
              message: 'Could not load recent sessions',
              onRetry: () => ref.invalidate(allCodingSessionsProvider),
            ),
          ),
        ),
      ],
    );
  }
}
