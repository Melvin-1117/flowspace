import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';

class TrialIndicator extends ConsumerWidget {
  const TrialIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionType = ref.watch(
      timerNotifierProvider.select((s) => s.sessionType),
    );
    final trialsRemaining = ref.watch(
      timerNotifierProvider.select((s) => s.trialsRemaining),
    );

    // Only show during focus sessions
    if (sessionType != SessionType.focus) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: trialsRemaining == 0
              ? AppTheme.danger.withValues(alpha: 0.3)
              : AppTheme.surfaceBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PAUSE ALLOWANCES',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                trialsRemaining == 0
                    ? 'No pauses remaining'
                    : '$trialsRemaining of 3 remaining',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: trialsRemaining == 0
                      ? AppTheme.danger
                      : AppTheme.textPrimary,
                ),
              ),
            ],
          ),

          // 3 dots
          Row(
            children: List.generate(3, (i) {
              final isAvailable = i < trialsRemaining;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAvailable ? AppTheme.primary : AppTheme.surfaceBorder,
                    boxShadow: isAvailable
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : null,
                  ),
                )
                    .animate(target: isAvailable ? 0 : 1)
                    .scaleXY(end: 0.7, duration: 300.ms),
              );
            }),
          ),
        ],
      ),
    );
  }
}
