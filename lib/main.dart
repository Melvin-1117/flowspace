import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app/theme.dart';

import 'core/models/focus_goal_settings.dart';
import 'core/models/focus_goal_settings_isar.dart';
import 'core/providers/isar_provider.dart';
import 'core/services/foreground_timer_service.dart';
import 'core/services/notification_service.dart';
import 'features/analytics/analytics_payload.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/planner/planner_screen.dart';
import 'features/planner/subject_detail_screen.dart';
import 'features/planner/subject_list_screen.dart';
import 'features/pomodoro/pomodoro_page.dart';
import 'features/pomodoro/providers/pomodoro_providers.dart';
import 'features/pomodoro/providers/pomodoro_web_store.dart';
import 'features/tasks/task_board_screen.dart';
import 'features/tasks/task_detail_screen.dart';
import 'home_page.dart';
import 'widgets/app_drawer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await ForegroundTimerService.initialize();
  runApp(const ProviderScope(child: FlowSpaceApp()));
}

class FlowSpaceApp extends ConsumerStatefulWidget {
  const FlowSpaceApp({super.key});

  @override
  ConsumerState<FlowSpaceApp> createState() => _FlowSpaceAppState();
}

class _FlowSpaceAppState extends ConsumerState<FlowSpaceApp> {
  bool _restored = false;

  late final GoRouter _router = GoRouter(
    initialLocation: '/focus',
    routes: [
      GoRoute(path: '/focus', builder: (_, __) => const HomePage()),
      GoRoute(path: '/tasks', builder: (_, __) => const TaskBoardScreen()),
      GoRoute(path: '/pomodoro', builder: (_, __) => const PomodoroPage()),
      GoRoute(
        path: '/tasks/:taskId',
        builder: (_, state) =>
            TaskDetailScreen(taskId: state.pathParameters['taskId']!),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) =>
            AnalyticsScreen(payload: state.extra as AnalyticsPayload?),
      ),
      GoRoute(path: '/planner', builder: (_, __) => const PlannerScreen()),
      GoRoute(
        path: '/planner/subjects',
        builder: (_, __) => const SubjectListScreen(),
      ),
      GoRoute(
        path: '/planner/subjects/:subjectId',
        builder: (_, state) =>
            SubjectDetailScreen(subjectId: state.pathParameters['subjectId']!),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => _PlaceholderScreen(title: 'Settings'),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    unawaited(_restoreAppState());
  }

  Future<void> _restoreAppState() async {
    final settings = kIsWeb
        ? PomodoroWebStore.instance.ensureSettings()
        : await (await ref.read(isarProvider.future)).focusGoalSettings.get(1)
              as FocusGoalSettings?;
    if (settings != null) {
      if (settings.wasTimerRunning && settings.killTimestamp != null) {
        final elapsed = DateTime.now()
            .difference(settings.killTimestamp!)
            .inSeconds;
        final correctedRemaining = settings.remainingSecondsOnKill - elapsed;
        if (correctedRemaining > 0) {
          await ref
              .read(timerNotifierProvider.notifier)
              .restoreSession(
                remainingSeconds: correctedRemaining,
                sessionType: SessionTypeFromName.fromName(
                  settings.sessionTypeOnKill,
                ),
              );
        } else {
          await ref
              .read(timerNotifierProvider.notifier)
              .handleExpiredWhileKilled();
        }
      }
    }
    if (mounted) {
      setState(() => _restored = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_restored) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const Scaffold(
          backgroundColor: AppTheme.background,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp.router(
      title: 'FlowSpace',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: AppTheme.darkTheme,
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  _PlaceholderScreen({required this.title});

  final String title;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$title screen',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This feature is coming soon!',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
