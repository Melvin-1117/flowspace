import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/pomodoro_providers.dart';
import '../../../app/theme.dart';

class DailyGoalCard extends ConsumerWidget {
  const DailyGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalProgress = ref.watch(dailyGoalProvider);
    return _sectionCard(
      child: InkWell(
        onTap: () => _showGoalSheet(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: goalProgress.when(
          data: (progress) {
            final color = progress.isReached
                ? AppTheme.success
                : AppTheme.primary;
            return Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress.percent,
                        strokeWidth: 4,
                        backgroundColor: AppTheme.surfaceElevated,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                      Text(
                        '${progress.completedSessions}/${progress.goalSessions}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DAILY FOCUS GOAL',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            progress.isReached
                                ? 'Goal Reached! 🎉'
                                : '${progress.percentValue}% Complete',
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (progress.isReached) ...[
                            const SizedBox(width: 8),
                            const Icon(
                                  Icons.celebration,
                                  color: AppTheme.success,
                                  size: 18,
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1.1, 1.1),
                                  duration: 900.ms,
                                ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const Text(
            'Daily goal unavailable',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }

  Future<void> _showGoalSheet(BuildContext context, WidgetRef ref) async {
    final settings = await ref.read(focusGoalSettingsProvider.future);
    var sliderValue = settings.dailySessionGoal.toDouble();
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final todayProgress = ref.watch(dailyGoalProvider);
            final weekly = ref.watch(weeklyHeatmapProvider);
            final streak = ref.watch(goalStreakProvider);
            final bestStreak = ref.watch(bestGoalStreakProvider);

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Focus Goal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),

                    // Row 1: Goal setting slider
                    Text(
                      '${sliderValue.round()} sessions',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: sliderValue,
                      min: 1,
                      max: 12,
                      divisions: 11,
                      onChanged: (value) => setState(() => sliderValue = value),
                    ),
                    const SizedBox(height: 12),

                    // Row 2: Today's progress ring + text
                    todayProgress.when(
                      data: (progress) => Row(
                        children: [
                          SizedBox(
                            width: 52,
                            height: 52,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: progress.percent,
                                  strokeWidth: 4,
                                  backgroundColor: AppTheme.surfaceElevated,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppTheme.primary,
                                  ),
                                ),
                                Text(
                                  '${progress.completedSessions}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${progress.completedSessions} of ${sliderValue.round()} sessions',
                            style: const TextStyle(color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      loading: () =>
                          const CircularProgressIndicator(strokeWidth: 2),
                      error: (_, __) =>
                          const Text('Progress unavailable'),
                    ),
                    const SizedBox(height: 16),

                    // Row 3: Weekly heatmap
                    const Text(
                      'Weekly heatmap',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    weekly.when(
                      data: (days) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: days.map((day) {
                          final label = DateFormat('E').format(day.date);
                          return Column(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: heatmapCellColor(day),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                label,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      loading: () =>
                          const CircularProgressIndicator(strokeWidth: 2),
                      error: (_, __) => const Text('Heatmap unavailable'),
                    ),
                    const SizedBox(height: 16),

                    // Row 4: current streak
                    streak.when(
                      data: (value) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🔥 $value day streak',
                          style: const TextStyle(color: AppTheme.textPrimary),
                        ),
                      ),
                      loading: () =>
                          const CircularProgressIndicator(strokeWidth: 2),
                      error: (_, __) => const Text('Streak unavailable'),
                    ),
                    const SizedBox(height: 10),

                    // Row 5: best streak
                    bestStreak.when(
                      data: (value) => Text(
                        'Best streak: $value days',
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          final existing =
                              await ref.read(focusGoalSettingsProvider.future);
                          existing.dailySessionGoal =
                              sliderValue.round().clamp(1, 12);
                          await ref
                              .read(focusGoalSettingsUpdaterProvider.notifier)
                              .updateSettings(existing);
                          ref.invalidate(dailyGoalProvider);
                          ref.invalidate(weeklyHeatmapProvider);
                          ref.invalidate(goalStreakProvider);
                          if (context.mounted) Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                        ),
                        child: const Text('Save Goal'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

Widget _sectionCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.surfaceCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0x1AFFFFFF)),
    ),
    child: child,
  );
}
