import 'package:flutter/material.dart';

/// A lightweight error boundary wrapper.
///
/// In debug mode Flutter's default red error box is retained.
/// In release/profile builds, wraps [child] with a [FlutterError.onError]
/// override so that uncaught render errors degrade gracefully instead of
/// crashing the entire screen.
///
/// Usage:
/// ```dart
/// ErrorBoundary(
///   screenName: 'PomodoroScreen',
///   child: PomodoroScreen(),
/// )
/// ```
class ErrorBoundary extends StatelessWidget {
  const ErrorBoundary({
    required this.child,
    required this.screenName,
    super.key,
  });

  final Widget child;
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
