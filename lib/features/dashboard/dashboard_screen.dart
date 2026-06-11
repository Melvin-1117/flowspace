import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';
import '../../core/widgets/user_avatar.dart';

import 'providers/dashboard_providers.dart';
import 'widgets/dashboard_content.dart';
import 'widgets/quick_action_sheet.dart';

import '../pomodoro/providers/pomodoro_providers.dart';
import '../pomodoro/services/alarm_service.dart';
import '../pomodoro/widgets/session_alarm_overlay.dart';
import '../../core/providers/calendar_providers.dart';
import '../tasks/providers/task_providers.dart';
import '../planner/providers/planner_providers.dart';
import '../analytics/providers/analytics_providers.dart';
import '../devtrack/providers/devtrack_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Listeners for reactivity
    ref.listen(todaySessionsProvider, (previous, next) {
      ref.invalidate(streakDaysProvider);
      ref.invalidate(dashboardStreakProvider);
      ref.invalidate(dashboardSessionsTodayProvider);
      ref.invalidate(semesterHealthProvider);
    });

    ref.listen(timerNotifierProvider, (previous, next) {
      ref.invalidate(dashboardIsSessionActiveProvider);
    });

    final showAlarm = ref.watch(alarmOverlayVisibleProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: buildFlowSpaceAppBar(
        scaffoldKey: _scaffoldKey,
        useTransparentBackground: true,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 24,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: UserAvatar(size: 36),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allTasksProvider);
              ref.invalidate(todaySessionsProvider);
              ref.invalidate(streakDaysProvider);
              ref.invalidate(allSubjectsProvider);
              ref.invalidate(allMilestonesProvider);
              ref.invalidate(todayFocusBlocksProvider);
              ref.invalidate(weeklyVelocityProvider);
              ref.invalidate(velocityChangeProvider);
              ref.invalidate(activityHeatmapProvider);
              ref.invalidate(todayCodingSessionsProvider);
              ref.invalidate(codingStreakProvider);
              ref.invalidate(activeProjectsProvider);
              ref.invalidate(nextMilestoneProvider);
              ref.invalidate(semesterHealthProvider);

              await Future.wait([
                ref.read(allTasksProvider.future).catchError((_) => []),
                ref.read(todaySessionsProvider.future).catchError((_) => []),
                ref.read(streakDaysProvider.future).catchError((_) => []),
                ref.read(allSubjectsProvider.future).catchError((_) => []),
                ref.read(nextMilestoneProvider.future).catchError((_) => null),
              ]);
            },
            child: const DashboardContent(),
          ),
          if (showAlarm)
            SessionAlarmOverlay(
              sessionNumber: ref.watch(sessionCountProvider),
              isLastBeforeLong: ref.watch(isLastBeforeLongProvider),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => const QuickActionSheet(),
          );
        },
        backgroundColor: AppTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}
