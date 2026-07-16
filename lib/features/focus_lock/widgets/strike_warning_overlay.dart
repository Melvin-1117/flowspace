import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';

/// Full-screen warning overlay shown when the user lifts the phone.
/// Auto-dismisses after 3 seconds. Shows escalating severity per strike.
class StrikeWarningOverlay extends StatefulWidget {
  const StrikeWarningOverlay({
    required this.strikeNumber,
    required this.onDismiss,
    super.key,
  });

  final int strikeNumber;
  final VoidCallback onDismiss;

  @override
  State<StrikeWarningOverlay> createState() => _StrikeWarningOverlayState();
}

class _StrikeWarningOverlayState extends State<StrikeWarningOverlay> {
  Timer? _autoDismissTimer;
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _autoDismissTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;
        setState(() => _countdown--);
        if (_countdown <= 0) {
          widget.onDismiss();
        }
      },
    );
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = [
      (
        icon: '⚠️',
        heading: 'Focus Break!',
        body: 'Put your phone face down\nto continue the session.',
        color: AppTheme.warning,
      ),
      (
        icon: '🚨',
        heading: 'Second Strike!',
        body: 'One more and your session\nwill be voided.',
        color: const Color(0xFFFF8C00),
      ),
      (
        icon: '💀',
        heading: 'Final Warning!',
        body: 'This is your last chance.\nFlip back NOW.',
        color: AppTheme.danger,
      ),
    ];

    final msg = messages[(widget.strikeNumber - 1).clamp(0, 2)];

    return Container(
      color: Colors.black.withValues(alpha: 0.9),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Strike icon
            Text(msg.icon, style: const TextStyle(fontSize: 64))
                .animate()
                .scaleXY(
                  begin: 0.5,
                  end: 1.0,
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 24),

            // Strike dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < widget.strikeNumber
                          ? msg.color
                          : AppTheme.surfaceBorder,
                      boxShadow: i < widget.strikeNumber
                          ? [
                              BoxShadow(
                                color: msg.color.withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'STRIKE ${widget.strikeNumber} OF 3',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: msg.color,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              msg.heading,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              msg.body,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 48),

            // Flip instruction icon
            Icon(
              Icons.screen_rotation_rounded,
              color: msg.color,
              size: 48,
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(end: 1.2, duration: 600.ms),

            const SizedBox(height: 12),

            Text(
              'Flip phone face down to continue',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Auto-dismiss countdown
            Text(
              'Resuming in $_countdown...',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
