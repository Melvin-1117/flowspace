import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../app/theme.dart';

/// Animated phone-flip illustration for the Focus Lock entry screen.
class PhoneFlipIllustration extends StatelessWidget {
  const PhoneFlipIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Table surface line
          Positioned(
            bottom: 8,
            child: Container(
              width: 200,
              height: 3,
              decoration: BoxDecoration(
                color: AppTheme.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Phone icon — rotates to simulate flipping
          const Icon(
            Icons.phone_android_rounded,
            color: AppTheme.primary,
            size: 64,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .rotate(
                begin: 0,
                end: 0.5,
                duration: 2000.ms,
                curve: Curves.easeInOutCubic,
              ),

          // Down arrow indicator
          Positioned(
            right: 60,
            child: Icon(
              Icons.south_rounded,
              color: AppTheme.primary.withValues(alpha: 0.5),
              size: 20,
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .slideY(begin: -0.3, end: 0.3, duration: 1000.ms),
          ),
        ],
      ),
    );
  }
}
