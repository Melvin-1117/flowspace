import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dashboard_providers.dart';
import 'active_focus_session_card.dart';
import 'calendar_widget.dart';
import 'greeting_header.dart';
import 'quick_stats_row.dart';
import 'daily_goal_card.dart';
import 'milestone_card.dart';
import 'task_summary_card.dart';
import 'semester_snapshot_card.dart';
import 'weekly_velocity_snapshot.dart';
import 'devtrack_snapshot_card.dart';
import 'upcoming_blocks_card.dart';
import 'welcome_card.dart';

class DashboardContent extends ConsumerWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNewUser = ref.watch(dashboardIsNewUserProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Greeting Header ──────────────────────────────────────
          const GreetingHeader(),
          const SizedBox(height: 20),

          // ── Welcome card for new users ──────────────────────────────
          if (isNewUser) ...[
            const WelcomeCard(),
            const SizedBox(height: 20),
          ],

          // ── 2. Quick Stats Row ──────────────────────────────────────
          const QuickStatsRow(),
          const SizedBox(height: 20),

          // ── 3. Active Focus Session Card ────────────────────────────
          const ActiveFocusSessionCard(),

          // ── 4. Daily Goal Card ──────────────────────────────────────
          const DailyGoalCard(),
          const SizedBox(height: 20),

          // ── 5. Calendar ─────────────────────────────────────────────
          const DashboardCalendarWidget(),
          const SizedBox(height: 20),

          // ── 6. Next Milestone ───────────────────────────────────────
          const MilestoneCard(),
          const SizedBox(height: 20),

          // ── 7. Task Summary ─────────────────────────────────────────
          const TaskSummaryCard(),
          const SizedBox(height: 20),

          // ── 8. Semester Health ───────────────────────────────────────
          const SemesterSnapshotCard(),
          const SizedBox(height: 20),

          // ── 9. Weekly Velocity ──────────────────────────────────────
          const WeeklyVelocitySnapshot(),
          const SizedBox(height: 20),

          // ── 10. DevTrack Snapshot ───────────────────────────────────
          const DevTrackSnapshotCard(),
          const SizedBox(height: 20),

          // ── 11. Upcoming Focus Blocks ───────────────────────────────
          const UpcomingBlocksCard(),
        ],
      ),
    );
  }
}
