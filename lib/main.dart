import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app/theme.dart';

import 'core/models/focus_goal_settings.dart';
import 'core/providers/isar_provider.dart';
import 'core/services/onboarding_service.dart';
import 'core/services/foreground_timer_service.dart';
import 'core/services/notification_service.dart';
import 'features/analytics/analytics_payload.dart';
import 'features/analytics/analytics_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/splash_screen.dart';
import 'features/planner/planner_screen.dart';
import 'features/planner/subject_detail_screen.dart';
import 'features/planner/subject_list_screen.dart';
import 'features/pomodoro/pomodoro_page.dart';
import 'features/pomodoro/providers/pomodoro_providers.dart';
import 'features/pomodoro/providers/pomodoro_web_store.dart';
import 'features/devtrack/devtrack_screen.dart';
import 'features/tasks/task_board_screen.dart';
import 'features/tasks/task_detail_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'widgets/app_drawer.dart';

Future<void> main() async {
  // Catch Flutter framework errors and show them on screen
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  // Catch async/platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('FATAL ERROR: $error\n$stack');
    return true;
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      try {
        await NotificationService.initialize();
      } catch (e) {
        debugPrint('NotificationService init error: $e');
      }
      try {
        await ForegroundTimerService.initialize();
      } catch (e) {
        debugPrint('ForegroundTimerService init error: $e');
      }
      runApp(const ProviderScope(child: FlowSpaceApp()));
    },
    (error, stack) {
      debugPrint('ZONE ERROR: $error\n$stack');
    },
  );
}

class FlowSpaceApp extends ConsumerStatefulWidget {
  const FlowSpaceApp({super.key});

  @override
  ConsumerState<FlowSpaceApp> createState() => _FlowSpaceAppState();
}

class _FlowSpaceAppState extends ConsumerState<FlowSpaceApp> {
  bool _restored = false;

  static Page<dynamic> _customPageTransition({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<dynamic>(
      key: key,
      child: child,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.03),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  late final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/focus',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/tasks',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const TaskBoardScreen(),
        ),
      ),
      GoRoute(
        path: '/pomodoro',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const PomodoroPage(),
        ),
      ),
      GoRoute(
        path: '/tasks/:taskId',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: TaskDetailScreen(taskId: state.pathParameters['taskId']!),
        ),
      ),
      GoRoute(
        path: '/analytics',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: AnalyticsScreen(payload: state.extra as AnalyticsPayload?),
        ),
      ),
      GoRoute(
        path: '/planner',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const PlannerScreen(),
        ),
      ),
      GoRoute(
        path: '/planner/subjects',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const SubjectListScreen(),
        ),
      ),
      GoRoute(
        path: '/planner/subjects/:subjectId',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: SubjectDetailScreen(subjectId: state.pathParameters['subjectId']!),
        ),
      ),
      GoRoute(
        path: '/devtrack',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: const DevTrackScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _customPageTransition(
          key: state.pageKey,
          child: _PlaceholderScreen(title: 'Settings'),
        ),
      ),
    ],
    redirect: (context, state) async {
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isSplash = state.matchedLocation == '/splash';

      // Always allow splash and onboarding.
      if (isSplash || isOnboarding) return null;

      // Check onboarding for all other routes.
      final container = ProviderScope.containerOf(context, listen: false);
      final isComplete = await container
          .read(onboardingServiceProvider)
          .isOnboardingComplete();

      if (!isComplete) return '/onboarding';
      return null;
    },
  );

  @override
  void initState() {
    super.initState();
    unawaited(_restoreAppState());
  }

  Future<void> _restoreAppState() async {
    final settings = kIsWeb
        ? PomodoroWebStore.instance.ensureSettings()
        : await (await ref.read(
            isarProvider.future,
          )).collection<FocusGoalSettings>().get(1);
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
