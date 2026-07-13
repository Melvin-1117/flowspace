import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';

/// Full settings bottom sheet accessible from the app bar tune icon.
class TimerSettingsSheet extends ConsumerWidget {
  const TimerSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(focusGoalSettingsProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: AppTheme.surfaceBorder),
          left: BorderSide(color: AppTheme.surfaceBorder),
          right: BorderSide(color: AppTheme.surfaceBorder),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.surfaceBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Timer Settings',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.surfaceBorder, height: 1),
          Flexible(
            child: settingsAsync.when(
              data: (settings) => ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                shrinkWrap: true,
                children: [
                  // Long break interval
                  _StepperSetting(
                    icon: Icons.repeat_rounded,
                    label: 'Long Break After',
                    description: 'Focus sessions before a long break',
                    value: settings.longBreakInterval,
                    min: 2,
                    max: 6,
                    suffix: ' sessions',
                    color: AppTheme.primary,
                    onChanged: (val) {
                      settings.longBreakInterval = val;
                      ref
                          .read(focusGoalSettingsUpdaterProvider.notifier)
                          .updateSettings(settings);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Daily session goal
                  _StepperSetting(
                    icon: Icons.flag_rounded,
                    label: 'Daily Session Goal',
                    description: 'Target focus sessions per day',
                    value: settings.dailySessionGoal,
                    min: 1,
                    max: 12,
                    suffix: ' sessions',
                    color: AppTheme.success,
                    onChanged: (val) {
                      settings.dailySessionGoal = val;
                      ref
                          .read(focusGoalSettingsUpdaterProvider.notifier)
                          .updateSettings(settings);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Auto-start breaks toggle
                  _ToggleSetting(
                    icon: Icons.play_circle_outline_rounded,
                    label: 'Auto-start Breaks',
                    description: 'Break starts automatically after focus ends',
                    value: settings.autoStartBreaks,
                    color: const Color(0xFF00B4FF),
                    onChanged: (val) {
                      settings.autoStartBreaks = val;
                      ref
                          .read(focusGoalSettingsUpdaterProvider.notifier)
                          .updateSettings(settings);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Auto-start focus toggle
                  _ToggleSetting(
                    icon: Icons.bolt_rounded,
                    label: 'Auto-start Focus',
                    description: 'Focus starts automatically after break ends',
                    value: settings.autoStartFocus,
                    color: AppTheme.primary,
                    onChanged: (val) {
                      settings.autoStartFocus = val;
                      ref
                          .read(focusGoalSettingsUpdaterProvider.notifier)
                          .updateSettings(settings);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Reset all
                  GestureDetector(
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: AppTheme.surfaceCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: AppTheme.surfaceBorder),
                          ),
                          title: Text(
                            'Reset All Settings?',
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          content: Text(
                            'This will restore all timer settings to defaults.',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: AppTheme.textSecondary),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.danger,
                              ),
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed != true) return;
                      settings
                        ..focusDuration = 1500
                        ..shortBreakDuration = 300
                        ..longBreakDuration = 900
                        ..dailySessionGoal = 4
                        ..longBreakInterval = 4
                        ..autoStartBreaks = false
                        ..autoStartFocus = false;
                      ref
                          .read(focusGoalSettingsUpdaterProvider.notifier)
                          .updateSettings(settings);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppTheme.danger.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.danger.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.restart_alt_rounded,
                              color: AppTheme.danger, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Reset All to Defaults',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.danger,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Could not load settings',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperSetting extends StatelessWidget {
  const _StepperSetting({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.color,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String description;
  final int value;
  final int min;
  final int max;
  final String suffix;
  final Color color;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Stepper controls
          GestureDetector(
            onTap: value > min ? () => onChanged(value - 1) : null,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Icon(
                Icons.remove_rounded,
                size: 14,
                color: value > min ? AppTheme.textSecondary : AppTheme.textMuted,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$value',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          GestureDetector(
            onTap: value < max ? () => onChanged(value + 1) : null,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  const _ToggleSetting({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: color,
            activeTrackColor: color.withValues(alpha: 0.3),
            inactiveThumbColor: AppTheme.textMuted,
            inactiveTrackColor: AppTheme.surfaceBorder,
          ),
        ],
      ),
    );
  }
}
