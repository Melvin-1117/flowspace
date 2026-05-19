import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class TimerRingPainter extends CustomPainter {
  const TimerRingPainter({required this.progress, required this.sessionColor});

  final double progress;
  final Color sessionColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final background = Paint()
      ..color = AppTheme.surfaceElevated
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(center, radius, background);

    final foreground = Paint()
      ..color = sessionColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * progress.clamp(0, 1);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, foreground);

    final tipAngle = -math.pi / 2 + sweep;
    final tip = Offset(
      center.dx + radius * math.cos(tipAngle),
      center.dy + radius * math.sin(tipAngle),
    );
    final glow = Paint()..color = sessionColor.withValues(alpha: 0.35);
    canvas.drawCircle(tip, 8, glow);
    final dot = Paint()..color = sessionColor;
    canvas.drawCircle(tip, 4, dot);
  }

  @override
  bool shouldRepaint(covariant TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sessionColor != sessionColor;
  }
}
