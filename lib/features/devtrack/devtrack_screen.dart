import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/constants/animation_tokens.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';
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
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppTheme.background,
      drawer: const AppDrawer(),
      appBar: buildFlowSpaceAppBar(scaffoldKey: scaffoldKey, title: 'DevTrack'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceMD,
            vertical: AppTheme.spaceSM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CodingStatsRow()
                  .animate()
                  .fadeIn(duration: kPageEntryDuration, curve: kPageEntryCurve)
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                  ),
              const SizedBox(height: AppTheme.spaceLG),
              const ActivityHeatmap()
                  .animate()
                  .fadeIn(
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep,
                  ),
              const SizedBox(height: AppTheme.spaceLG),
              const LanguageDonutChart()
                  .animate()
                  .fadeIn(
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep * 2,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep * 2,
                  ),
              const SizedBox(height: AppTheme.spaceLG),
              const ActiveProjectsSection()
                  .animate()
                  .fadeIn(
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep * 3,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep * 3,
                  ),
              const SizedBox(height: AppTheme.spaceLG),
              const SkillTrackerSection()
                  .animate()
                  .fadeIn(
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep * 4,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep * 4,
                  ),
              const SizedBox(height: AppTheme.spaceLG),
              const RecentSessionsSection()
                  .animate()
                  .fadeIn(
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep * 5,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: kPageEntryDuration,
                    curve: kPageEntryCurve,
                    delay: kPageStaggerStep * 5,
                  ),
              const SizedBox(height: 80), // spacer for FAB
            ],
          ),
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
        label: const Text(
          'Log Session',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        backgroundColor: AppTheme.primary,
        elevation: 4,
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}
