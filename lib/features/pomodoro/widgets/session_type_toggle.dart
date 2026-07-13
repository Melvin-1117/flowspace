import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';

class SessionTypeToggle extends ConsumerWidget {
  const SessionTypeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentType = ref.watch(sessionTypeProvider);
    final settings = ref.watch(focusGoalSettingsProvider).value;

    if (settings == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          // Focus tab
          _SessionTab(
            icon: Icons.bolt_rounded,
            label: 'Focus',
            duration: settings.focusDuration,
            isActive: currentType == SessionType.focus,
            color: const Color(0xFF006EE6),
            onTap: () => _onTabTap(context, SessionType.focus, ref),
          ),

          // Short Break tab
          _SessionTab(
            icon: Icons.coffee_rounded,
            label: 'Short',
            duration: settings.shortBreakDuration,
            isActive: currentType == SessionType.shortBreak,
            color: const Color(0xFF00B4FF),
            onTap: () => _onTabTap(context, SessionType.shortBreak, ref),
          ),

          // Long Break tab
          _SessionTab(
            icon: Icons.self_improvement_rounded,
            label: 'Long',
            duration: settings.longBreakDuration,
            isActive: currentType == SessionType.longBreak,
            color: const Color(0xFF00D4AA),
            onTap: () => _onTabTap(context, SessionType.longBreak, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _onTabTap(
    BuildContext context,
    SessionType type,
    WidgetRef ref,
  ) async {
    final timerState = ref.read(timerNotifierProvider);
    if (timerState.sessionType == type) return;

    final hasProgress =
        timerState.remainingSeconds != timerState.totalDurationSeconds;

    if (timerState.isRunning || hasProgress) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => _SwitchConfirmDialog(newType: type),
      );
      if (confirmed != true) return;
    }
    await ref.read(timerNotifierProvider.notifier).switchType(type);
  }
}

class _SessionTab extends StatelessWidget {
  const _SessionTab({
    required this.icon,
    required this.label,
    required this.duration,
    required this.isActive,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int duration;
  final bool isActive;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? color.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? color.withValues(alpha: 0.4) : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? color : AppTheme.textMuted,
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? color : AppTheme.textMuted,
                ),
              ),
              Text(
                '${duration ~/ 60}m',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  color: isActive ? color.withValues(alpha: 0.7) : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchConfirmDialog extends StatelessWidget {
  const _SwitchConfirmDialog({required this.newType});

  final SessionType newType;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.surfaceBorder),
      ),
      title: Text(
        'Switch to ${newType.label}?',
        style: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
      content: Text(
        'Current session progress will be lost.',
        style: GoogleFonts.spaceGrotesk(
          color: AppTheme.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
