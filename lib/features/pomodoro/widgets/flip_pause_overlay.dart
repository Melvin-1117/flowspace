import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';

/// Full-screen dark overlay shown when the phone is flipped face-down
/// during a focus session. Instructs the user to flip back to resume.
class FlipPauseOverlay extends ConsumerWidget {
  const FlipPauseOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.92),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Phone icon rotated 180°
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.95, end: 1.1),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Transform.rotate(
                  angle: pi,
                  child: const Icon(
                    Icons.phone_android_rounded,
                    color: AppTheme.primary,
                    size: 72,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Session Paused heading
              Text(
                'Session Paused',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 12),

              // Instruction
              Text(
                'Flip your phone back to resume',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(height: 48),

              // Pulsing up arrow
              _PulsingArrow(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingArrow extends StatefulWidget {
  @override
  State<_PulsingArrow> createState() => _PulsingArrowState();
}

class _PulsingArrowState extends State<_PulsingArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _slideAnim = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: child,
        );
      },
      child: const Icon(
        Icons.keyboard_arrow_up_rounded,
        color: AppTheme.primary,
        size: 52,
      ),
    );
  }
}
