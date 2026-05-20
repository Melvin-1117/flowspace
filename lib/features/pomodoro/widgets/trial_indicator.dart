import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';

/// Shows 3 dots indicating the number of manual pause allowances remaining
/// during a focus session. Hidden during break sessions.
class TrialIndicator extends ConsumerWidget {
  const TrialIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerNotifierProvider);

    // Hide during break sessions
    if (state.sessionType != SessionType.focus) {
      return const SizedBox.shrink();
    }

    final trialsRemaining = state.trialsRemaining;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Three dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isAvailable = index < trialsRemaining;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAvailable
                      ? AppTheme.primary
                      : AppTheme.surfaceBorder,
                  boxShadow: isAvailable
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 8),

        // Label
        Text(
          trialsRemaining == 0
              ? 'No pauses remaining'
              : '$trialsRemaining pause${trialsRemaining == 1 ? '' : 's'} remaining',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: trialsRemaining == 0
                ? AppTheme.danger
                : AppTheme.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
