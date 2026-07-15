import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/pomodoro_providers.dart';
import '../../../app/theme.dart';
import '../../../core/widgets/error_card.dart';

class DailyGoalCard extends ConsumerWidget {
  const DailyGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(focusGoalSettingsProvider);
    final sessionsAsync = ref.watch(todaySessionsProvider);

    return settingsAsync.when(
      data: (settings) => sessionsAsync.when(
        data: (sessions) {
          final completed = sessions
              .where((s) => s.isCompleted && s.sessionType == 'focus')
              .length;
          final goal = settings.dailySessionGoal;
          final percent = (completed / goal).clamp(0.0, 1.0);
          final isGoalMet = completed >= goal;

          return GestureDetector(
            onTap: () => _showGoalSheet(context, ref),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isGoalMet
                      ? AppTheme.success.withValues(alpha: 0.4)
                      : AppTheme.surfaceBorder,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Mini ring
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: CustomPaint(
                          painter: GoalRingPainter(
                            progress: percent,
                            color: isGoalMet
                                ? AppTheme.success
                                : AppTheme.primary,
                          ),
                          child: Center(
                            child: Text(
                              '$completed/$goal',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isGoalMet
                                    ? AppTheme.success
                                    : AppTheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DAILY FOCUS GOAL',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textSecondary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isGoalMet
                                  ? 'Goal Reached! 🎯'
                                  : '${(percent * 100).round()}% Complete',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isGoalMet
                                    ? AppTheme.success
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppTheme.textMuted,
                        size: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Session dots row (visual progress)
                  Row(
                    children: List.generate(goal, (i) {
                      final isComplete = i < completed;
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: i < goal - 1 ? 4 : 0),
                          height: 4,
                          decoration: BoxDecoration(
                            color: isComplete
                                ? (isGoalMet
                                      ? AppTheme.success
                                      : AppTheme.primary)
                                : AppTheme.surfaceBorder,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const SizedBox(
          height: 90,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (err, _) => ErrorCard(
          message: 'Could not load sessions',
          onRetry: () => ref.invalidate(todaySessionsProvider),
        ),
      ),
      loading: () => const SizedBox(
        height: 90,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, _) => ErrorCard(
        message: 'Could not load goal settings',
        onRetry: () => ref.invalidate(focusGoalSettingsProvider),
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
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final weekly = ref.watch(weeklyHeatmapProvider);
            final streak = ref.watch(goalStreakProvider);
            final bestStreak = ref.watch(bestGoalStreakProvider);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DAILY FOCUS GOAL',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                            letterSpacing: 1.6,
                          ),
                        ),
                        Text(
                          '${sliderValue.round()} sessions',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Slider
                    Slider(
                      value: sliderValue,
                      min: 1,
                      max: 12,
                      divisions: 11,
                      activeColor: AppTheme.primary,
                      inactiveColor: AppTheme.surfaceBorder,
                      onChanged: (val) {
                        setModalState(() => sliderValue = val);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Weekly Heatmap
                    Text(
                      'WEEKLY HEATMAP',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                              const SizedBox(height: 6),
                              Text(
                                label,
                                style: GoogleFonts.spaceGrotesk(
                                  color: AppTheme.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      error: (_, __) => const Text('Heatmap unavailable'),
                    ),
                    const SizedBox(height: 24),

                    // Streaks
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        streak.when(
                          data: (val) => Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department_rounded,
                                color: AppTheme.warning,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$val day streak',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                        bestStreak.when(
                          data: (val) => Text(
                            'Best: $val days',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.textSecondary,
                              side: const BorderSide(
                                color: AppTheme.surfaceBorder,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              final existing = await ref.read(
                                focusGoalSettingsProvider.future,
                              );
                              existing.dailySessionGoal = sliderValue
                                  .round()
                                  .clamp(1, 12);
                              await ref
                                  .read(
                                    focusGoalSettingsUpdaterProvider.notifier,
                                  )
                                  .updateSettings(existing);
                              ref.invalidate(dailyGoalProvider);
                              ref.invalidate(weeklyHeatmapProvider);
                              ref.invalidate(goalStreakProvider);
                              if (context.mounted) Navigator.pop(context);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Save Goal'),
                          ),
                        ),
                      ],
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

class GoalRingPainter extends CustomPainter {
  GoalRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 3) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = const Color(0xFF1A2640)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0.001) return;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GoalRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
