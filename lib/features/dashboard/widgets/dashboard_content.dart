import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/animation_tokens.dart';
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
          RepaintBoundary(
            child: const GreetingHeader()
                .animate()
                .fadeIn(duration: kPageEntryDuration, curve: kPageEntryCurve)
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── Welcome card for new users ──────────────────────────────
          if (isNewUser) ...[
            RepaintBoundary(
              child: const WelcomeCard()
                  .animate()
                  .fadeIn(
                    duration: kPageEntryDuration,
                    delay: kPageStaggerStep,
                    curve: kPageEntryCurve,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: kPageEntryDuration,
                    delay: kPageStaggerStep,
                    curve: kPageEntryCurve,
                  ),
            ),
            const SizedBox(height: 20),
          ],

          // ── 2. Quick Stats Row ──────────────────────────────────────
          RepaintBoundary(
            child: const QuickStatsRow()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 2,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 2,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── 3. Active Focus Session Card ────────────────────────────
          RepaintBoundary(
            child: const ActiveFocusSessionCard()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 3,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 3,
                  curve: kPageEntryCurve,
                ),
          ),

          // ── 4. Daily Goal Card ──────────────────────────────────────
          RepaintBoundary(
            child: const DailyGoalCard()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 4,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 4,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── 5. Calendar ─────────────────────────────────────────────
          RepaintBoundary(
            child: const DashboardCalendarWidget()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 5,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 5,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── 6. Next Milestone ───────────────────────────────────────
          RepaintBoundary(
            child: const MilestoneCard()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 6,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 6,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── 7. Task Summary ─────────────────────────────────────────
          RepaintBoundary(
            child: const TaskSummaryCard()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 7,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 7,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── 8. Semester Health ───────────────────────────────────────
          RepaintBoundary(
            child: const SemesterSnapshotCard()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 8,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 8,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── 9. Weekly Velocity ──────────────────────────────────────
          RepaintBoundary(
            child: const WeeklyVelocitySnapshot()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 9,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 9,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── 10. DevTrack Snapshot ───────────────────────────────────
          RepaintBoundary(
            child: const DevTrackSnapshotCard()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 10,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 10,
                  curve: kPageEntryCurve,
                ),
          ),
          const SizedBox(height: 20),

          // ── 11. Upcoming Focus Blocks ───────────────────────────────
          RepaintBoundary(
            child: const UpcomingBlocksCard()
                .animate()
                .fadeIn(
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 11,
                  curve: kPageEntryCurve,
                )
                .slideY(
                  begin: 0.06,
                  end: 0,
                  duration: kPageEntryDuration,
                  delay: kPageStaggerStep * 11,
                  curve: kPageEntryCurve,
                ),
          ),
        ],
      ),
    );
  }
}
