import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/focus_lock_providers.dart';

/// Shows today's Focus Lock stats on the entry screen.
/// Only visible when at least one session exists today.
class TodayFocusLockStats extends ConsumerWidget {
  const TodayFocusLockStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(todayFocusLockSessionsProvider);

    return sessionsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (sessions) {
        if (sessions.isEmpty) return const SizedBox.shrink();

        final completed =
            sessions.where((s) => s.isCompleted && !s.isVoid).length;
        final voided = sessions.where((s) => s.isVoid).length;
        final totalMins = sessions
            .where((s) => s.isCompleted && !s.isVoid)
            .fold(0, (sum, s) => sum + s.durationMinutes);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.surfaceBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TODAY'S FOCUS LOCK",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatChip(
                    value: '$completed',
                    label: 'Completed',
                    color: AppTheme.success,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    value: '${totalMins}m',
                    label: 'Focused',
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 8),
                  _StatChip(
                    value: '$voided',
                    label: 'Void',
                    color: AppTheme.danger,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
