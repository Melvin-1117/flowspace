import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pomodoro_providers.dart';
import 'timer_ring_painter.dart';

class TimerRing extends ConsumerStatefulWidget {
  const TimerRing({super.key});

  @override
  ConsumerState<TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends ConsumerState<TimerRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _overlayAutoDismiss;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _overlayAutoDismiss?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerNotifierProvider);
    final sessionColor = timerState.sessionType.color;

    // Render smooth decay between one-second state commits.
    final drift = timerState.isRunning
        ? DateTime.now().difference(timerState.lastTickAt).inMilliseconds / 1000
        : 0.0;
    // Ensure remaining seconds is valid before applying drift
    final validRemaining = timerState.remainingSeconds < 0
        ? 0
        : timerState.remainingSeconds;
    final smoothRemaining = math.max(0.0, validRemaining - drift);
    final smoothProgress = timerState.totalDurationSeconds <= 0
        ? 0.0
        : (smoothRemaining / timerState.totalDurationSeconds).clamp(0.0, 1.0);

    if (timerState.isRunning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!timerState.isRunning && _controller.isAnimating) {
      _controller.stop();
    }

    final minutes = (smoothRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (smoothRemaining.toInt() % 60).toString().padLeft(2, '0');

    if (timerState.completionOverlay != null) {
      _overlayAutoDismiss ??= Timer(const Duration(seconds: 5), () {
        ref.read(timerNotifierProvider.notifier).dismissCompletionOverlay();
      });
    } else {
      _overlayAutoDismiss?.cancel();
      _overlayAutoDismiss = null;
    }

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(300),
            painter: TimerRingPainter(
              progress: smoothProgress,
              sessionColor: sessionColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$minutes:$seconds',
                style: const TextStyle(
                  color: Color(0xFFF0F0F0),
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
