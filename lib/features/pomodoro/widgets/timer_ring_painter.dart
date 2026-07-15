import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Enhanced timer ring painter with glow effects and glowing tip dot.
class TimerRingPainter extends CustomPainter {
  const TimerRingPainter({
    required this.progress,
    required this.sessionColor,
    this.strokeWidth = 8,
  });

  final double progress;
  final Color sessionColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

    // Background track ring
    final trackPaint = Paint()
      ..color = const Color(0xFF1A2640)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0.001) return;

    // Glow paint
    final glowPaint = Paint()
      ..color = sessionColor.withValues(alpha: 0.35)
      ..strokeWidth = strokeWidth + 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);

    // Main arc paint
    final arcPaint = Paint()
      ..color = sessionColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);

    // Glowing tip dot
    final tipAngle = startAngle + sweepAngle;
    final tipX = center.dx + radius * math.cos(tipAngle);
    final tipY = center.dy + radius * math.sin(tipAngle);
    final tipOffset = Offset(tipX, tipY);

    // Outer glow
    final dotGlow = Paint()
      ..color = sessionColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(tipOffset, strokeWidth / 2 + 2, dotGlow);

    // Inner white dot
    canvas.drawCircle(
      tipOffset,
      strokeWidth / 2,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sessionColor != sessionColor;
  }
}
