import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../devtrack/providers/devtrack_providers.dart';

class DevTrackSnapshotCard extends ConsumerWidget {
  const DevTrackSnapshotCard({super.key});

  Color _getCellColor(int minutes) {
    if (minutes == 0) return AppTheme.surfaceElevated;
    if (minutes <= 30) return AppTheme.primary.withOpacity(0.25);
    if (minutes <= 90) return AppTheme.primary.withOpacity(0.5);
    if (minutes <= 180) return AppTheme.primary.withOpacity(0.75);
    return AppTheme.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatmapAsync = ref.watch(activityHeatmapProvider);
    final todaySessionsAsync = ref.watch(todayCodingSessionsProvider);
    final streakAsync = ref.watch(codingStreakProvider);
    final projectsAsync = ref.watch(activeProjectsProvider);

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DEVTRACK SNAPSHOT',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/devtrack'),
                child: Row(
                  children: [
                    Text(
                      'View DevTrack',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: AppTheme.primaryLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mini heatmap (28 days)
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECENT ACTIVITY',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    heatmapAsync.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const SizedBox(
                            height: 60,
                            child: Center(child: Text('-', style: TextStyle(color: AppTheme.textMuted))),
                          );
                        }

                        // Take last 28 days
                        final miniData = data.length > 28
                            ? data.sublist(data.length - 28)
                            : data;

                        return SizedBox(
                          height: 55,
                          width: 110,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                            ),
                            itemCount: miniData.length,
                            itemBuilder: (context, index) {
                              final dayData = miniData[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: _getCellColor(dayData.codingMinutes),
                                  borderRadius: BorderRadius.circular(1.5),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      loading: () => const SizedBox(
                        height: 55,
                        child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1.5))),
                      ),
                      error: (err, stack) => const Icon(Icons.error_outline, color: AppTheme.danger, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTheme.spaceMD),
              // Stats
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TODAY',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            todaySessionsAsync.when(
                              data: (sessions) {
                                final totalMinutes = sessions.fold(0, (sum, s) => sum + s.durationMinutes);
                                if (totalMinutes < 60) {
                                  return Text(
                                    '${totalMinutes}m',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  );
                                }
                                final hours = totalMinutes / 60.0;
                                return Text(
                                  '${hours.toStringAsFixed(1)}h',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                );
                              },
                              loading: () => const Text('...', style: TextStyle(fontSize: 16, color: Colors.white)),
                              error: (e, s) => const Text('0m', style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STREAK',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            streakAsync.when(
                              data: (streak) => Text(
                                '$streak days',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              loading: () => const Text('...', style: TextStyle(fontSize: 16, color: Colors.white)),
                              error: (e, s) => const Text('0 days', style: TextStyle(fontSize: 16, color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'TOP PROJECT',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    projectsAsync.when(
                      data: (projects) {
                        if (projects.isEmpty) {
                          return Text(
                            'No active projects',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          );
                        }
                        // Sort by totalCodingMinutes or lastActiveAt
                        final topProject = projects.first;
                        return Text(
                          topProject.name,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                      loading: () => const Text('...', style: TextStyle(fontSize: 12, color: Colors.white)),
                      error: (e, s) => const Text('-', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
