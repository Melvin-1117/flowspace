import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import 'widgets/active_projects_section.dart';
import 'widgets/activity_heatmap.dart';
import 'widgets/coding_stats_row.dart';
import 'widgets/language_donut_chart.dart';
import 'widgets/log_session_sheet.dart';
import 'widgets/recent_sessions_section.dart';
import 'widgets/skill_tracker_section.dart';

class DevTrackScreen extends ConsumerWidget {
  const DevTrackScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'DevTrack',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        elevation: 0,
        backgroundColor: AppTheme.background,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMD,
          vertical: AppTheme.spaceSM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CodingStatsRow(),
            const SizedBox(height: AppTheme.spaceLG),
            const ActivityHeatmap(),
            const SizedBox(height: AppTheme.spaceLG),
            const LanguageDonutChart(),
            const SizedBox(height: AppTheme.spaceLG),
            const ActiveProjectsSection(),
            const SizedBox(height: AppTheme.spaceLG),
            const SkillTrackerSection(),
            const SizedBox(height: AppTheme.spaceLG),
            const RecentSessionsSection(),
            const SizedBox(height: 80), // spacer for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const LogSessionSheet(),
          );
        },
        label: Text(
          'Log Session',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        backgroundColor: AppTheme.primary,
        elevation: 4,
      ),
    );
  }
}
