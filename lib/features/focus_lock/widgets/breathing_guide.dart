import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';

/// Subtle breathing circle to help users stay calm during locked session.
/// Inhale (scale up 4s) → Exhale (scale down 4s) → repeat.
class BreathingGuide extends StatelessWidget {
  const BreathingGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'breathe',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            color: AppTheme.textMuted,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.2),
            ),
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .scaleXY(
              begin: 0.6,
              end: 1.0,
              duration: 4000.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scaleXY(
              begin: 1.0,
              end: 0.6,
              duration: 4000.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }
}
