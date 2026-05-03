import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/pomodoro/pomodoro_page.dart';
import 'features/tasks/task_board_screen.dart';
import 'features/tasks/task_detail_screen.dart';
import 'home_page.dart';

void main() {
  runApp(const ProviderScope(child: FlowSpaceApp()));
}

class FlowSpaceApp extends StatelessWidget {
  const FlowSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/tasks',
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
          path: '/planner',
          builder: (_, __) => const _PlaceholderScreen(title: 'Planner'),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const _PlaceholderScreen(title: 'Settings'),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'FlowSpace',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C3AED),
          surface: Color(0xFF0D0D0D),
          onSurface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: Text(title),
      ),
      body: Center(child: Text('$title screen')),
    );
  }
}
