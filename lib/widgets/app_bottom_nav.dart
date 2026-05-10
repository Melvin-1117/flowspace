/// Shared bottom navigation bar for FlowSpace.
///
/// All screens that need a bottom nav should use [AppBottomNav] instead of
/// building their own [BottomNavigationBar]. Pass only [currentIndex] — the
/// items, colours, styles, and routing logic are all canonical here.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────
const Color kNavBackground = Color(0xFF09090B);
const Color kNavSelectedColor = Color(0xFF7C3AED);
const Color kNavUnselectedColor = Color(0xFF7A7A83);
const TextStyle kNavSelectedLabel = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w700,
  letterSpacing: 1,
);
const TextStyle kNavUnselectedLabel = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w600,
  letterSpacing: 1,
);

/// Route paths indexed by nav position (0-4).
const List<String> _navRoutes = [
  '/focus',
  '/tasks',
  '/pomodoro',
  '/planner',
  '/settings',
];

/// Canonical bottom navigation bar shared by all main screens.
///
/// ```dart
/// bottomNavigationBar: AppBottomNav(currentIndex: 0),
/// ```
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({required this.currentIndex, super.key});

  /// Zero-based index of the currently active tab (0 = Focus … 4 = GitHub).
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kNavBackground,
        selectedItemColor: kNavSelectedColor,
        unselectedItemColor: kNavUnselectedColor,
        selectedLabelStyle: kNavSelectedLabel,
        unselectedLabelStyle: kNavUnselectedLabel,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return; // already on this tab
          context.go(_navRoutes[index]);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'FOCUS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            activeIcon: Icon(Icons.check_circle),
            label: 'TASKS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_top_rounded),
            activeIcon: Icon(Icons.hourglass_bottom_rounded),
            label: 'POMO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'PLANNER',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code_outlined),
            activeIcon: Icon(Icons.code),
            label: 'GITHUB',
          ),
        ],
      ),
    );
  }
}
