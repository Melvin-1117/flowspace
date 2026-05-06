import 'package:flutter/material.dart';

const Duration _progressAnimationDuration = Duration(milliseconds: 600);
const Curve _progressAnimationCurve = Curves.easeOutCubic;

class StatProgressBar extends StatelessWidget {
  const StatProgressBar({
    required this.value,
    required this.fillColor,
    this.backgroundColor = const Color(0xFF1A1A1A),
    this.height = 4,
    super.key,
  });

  final double value;
  final Color fillColor;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: clampedValue),
        duration: _progressAnimationDuration,
        curve: _progressAnimationCurve,
        builder: (context, animatedValue, _) {
          return LinearProgressIndicator(
            value: animatedValue,
            minHeight: height,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(fillColor),
          );
        },
      ),
    );
  }
}
