import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/pomodoro_providers.dart';

/// Editable timing card that allows inline duration changes for
/// focus, short break, and long break durations.
class EditableTimingCard extends ConsumerWidget {
  const EditableTimingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(focusGoalSettingsProvider);
    final isEditing = ref.watch(isEditingTimerProvider);
    final isRunning = ref.watch(
      timerNotifierProvider.select((s) => s.isRunning),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SESSION DURATIONS',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.0,
                ),
              ),
              GestureDetector(
                onTap: () => ref.read(isEditingTimerProvider.notifier).state =
                    !isEditing,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isEditing
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isEditing
                          ? AppTheme.primary.withValues(alpha: 0.4)
                          : AppTheme.surfaceBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isEditing ? Icons.check_rounded : Icons.edit_rounded,
                        size: 12,
                        color: isEditing
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isEditing ? 'Done' : 'Edit',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          color: isEditing
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Duration tiles
          settingsAsync.when(
            data: (settings) {
              final canEdit = isEditing && !isRunning;
              return Column(
                children: [
                  _DurationTile(
                    icon: Icons.bolt_rounded,
                    label: 'Focus',
                    currentMinutes: settings.focusDuration ~/ 60,
                    color: const Color(0xFF006EE6),
                    isEditing: canEdit,
                    minMinutes: 5,
                    maxMinutes: 90,
                    onChanged: (minutes) {
                      settings.focusDuration = minutes * 60;
                      ref
                          .read(focusGoalSettingsUpdaterProvider.notifier)
                          .updateSettings(settings);
                    },
                  ),
                  const SizedBox(height: 8),
                  _DurationTile(
                    icon: Icons.coffee_rounded,
                    label: 'Short Break',
                    currentMinutes: settings.shortBreakDuration ~/ 60,
                    color: const Color(0xFF00B4FF),
                    isEditing: canEdit,
                    minMinutes: 1,
                    maxMinutes: 30,
                    onChanged: (minutes) {
                      settings.shortBreakDuration = minutes * 60;
                      ref
                          .read(focusGoalSettingsUpdaterProvider.notifier)
                          .updateSettings(settings);
                    },
                  ),
                  const SizedBox(height: 8),
                  _DurationTile(
                    icon: Icons.self_improvement_rounded,
                    label: 'Long Break',
                    currentMinutes: settings.longBreakDuration ~/ 60,
                    color: const Color(0xFF00D4AA),
                    isEditing: canEdit,
                    minMinutes: 5,
                    maxMinutes: 60,
                    onChanged: (minutes) {
                      settings.longBreakDuration = minutes * 60;
                      ref
                          .read(focusGoalSettingsUpdaterProvider.notifier)
                          .updateSettings(settings);
                    },
                  ),
                  // Lock message when running
                  if (isRunning && isEditing) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.warning.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppTheme.warning,
                            size: 14,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Duration changes apply from next session',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11,
                                color: AppTheme.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => Text(
              'Could not load settings',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationTile extends StatelessWidget {
  const _DurationTile({
    required this.icon,
    required this.label,
    required this.currentMinutes,
    required this.color,
    required this.isEditing,
    required this.minMinutes,
    required this.maxMinutes,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final int currentMinutes;
  final Color color;
  final bool isEditing;
  final int minMinutes;
  final int maxMinutes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isEditing
              ? color.withValues(alpha: 0.3)
              : AppTheme.surfaceBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          if (isEditing) ...[
            // Decrease button
            GestureDetector(
              onTap: () {
                if (currentMinutes > minMinutes) {
                  onChanged(currentMinutes - 1);
                }
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: const Icon(
                  Icons.remove_rounded,
                  size: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          // Value display
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              '${currentMinutes}m',
              key: ValueKey(currentMinutes),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isEditing ? color : AppTheme.textPrimary,
              ),
            ),
          ),
          if (isEditing) ...[
            const SizedBox(width: 8),
            // Increase button
            GestureDetector(
              onTap: () {
                if (currentMinutes < maxMinutes) {
                  onChanged(currentMinutes + 1);
                }
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
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
        ],
      ),
    );
  }
}
