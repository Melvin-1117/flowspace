import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/animation_tokens.dart';
import '../../../core/models/analytics_models.dart';
import 'analytics_empty_state.dart';
import '../providers/analytics_providers.dart';
import '../../../app/theme.dart';

const Color _cardBackground = AppTheme.surfaceCard;
const Color _cardBorder = Color(0x0DFFFFFF);
const Color _textPrimary = AppTheme.textPrimary;
const Color _textSecondary = AppTheme.textSecondary;
const Color _gridColor = AppTheme.surfaceElevated;
const Color _purple = AppTheme.primary;
const Color _barDefault = AppTheme.surfaceElevated;
const Color _barTouched = AppTheme.primaryLight;
const Color _success = AppTheme.success;
const Color _danger = AppTheme.danger;
const double _barWidth = 28;
const List<String> _weekdayLabels = <String>[
  'MON',
  'TUE',
  'WED',
  'THU',
  'FRI',
  'SAT',
  'SUN',
];

class WeeklyVelocityChart extends ConsumerStatefulWidget {
  const WeeklyVelocityChart({super.key});

  @override
  ConsumerState<WeeklyVelocityChart> createState() =>
      _WeeklyVelocityChartState();
}

class _WeeklyVelocityChartState extends ConsumerState<WeeklyVelocityChart>
    with SingleTickerProviderStateMixin {
  int _touchedIndex = -1;
  late final AnimationController _barAnimationController;

  @override
  void initState() {
    super.initState();
    _barAnimationController = AnimationController(
      vsync: this,
      duration: kChartDuration,
    )..forward();
  }

  @override
  void dispose() {
    _barAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final velocityData = ref.watch(weeklyVelocityProvider);
    final velocityChange = ref.watch(velocityChangeProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Weekly Velocity',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              velocityChange.when(
                data: (change) => _ChangeBadge(change: change),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Activity output vs baseline performance',
            style: TextStyle(color: _textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: velocityData.when(
              data: (rows) {
                if (rows.every((row) => row.totalMinutes == 0)) {
                  return const Center(
                    child: AnalyticsEmptyState(
                      message: 'Complete focus sessions to visualize velocity.',
                      icon: Icons.bar_chart_rounded,
                    ),
                  );
                }
                return AnimatedBuilder(
                  animation: _barAnimationController,
                  builder: (_, __) {
                    return BarChart(
                      BarChartData(
                        maxY: _maxMinutes(rows).toDouble(),
                        gridData: FlGridData(
                          drawVerticalLine: false,
                          horizontalInterval: 30,
                          getDrawingHorizontalLine: (_) =>
                              const FlLine(color: _gridColor, strokeWidth: 1),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= _weekdayLabels.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    _weekdayLabels[index],
                                    style: const TextStyle(
                                      color: _textSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List<BarChartGroupData>.generate(
                          rows.length,
                          (index) => _buildBarGroup(rows[index], index),
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => AppTheme.surfaceElevated,
                            getTooltipItem: (group, _, rod, __) {
                              final row = rows[group.x.toInt()];
                              return BarTooltipItem(
                                '${row.sessionCount} focus sessions • ${row.totalMinutes} minutes',
                                const TextStyle(
                                  color: _textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          touchCallback: (event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.spot == null) {
                                _touchedIndex = -1;
                              } else {
                                _touchedIndex = response.spot!.touchedBarGroupIndex;
                              }
                            });
                          },
                        ),
                      ),
                      swapAnimationDuration: Duration.zero,
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => const Center(
                child: AnalyticsEmptyState(
                  message: 'Complete focus sessions to visualize velocity.',
                  icon: Icons.bar_chart_rounded,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(DayVelocity item, int index) {
    final isTouched = _touchedIndex == index;
    final color = isTouched
        ? _barTouched
        : (item.isToday ? _purple : _barDefault);
    final slice = CurvedAnimation(
      parent: _barAnimationController,
      curve: Interval(
        (index * 0.08).clamp(0.0, 0.65),
        (0.5 + index * 0.08).clamp(0.35, 1.0),
        curve: Curves.easeOutCubic,
      ),
    ).value;
    return BarChartGroupData(
      x: item.weekday,
      barRods: [
        BarChartRodData(
          toY: item.totalMinutes.toDouble() * slice,
          width: _barWidth,
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  int _maxMinutes(List<DayVelocity> rows) {
    final maxMinutes = rows.fold<int>(
      0,
      (previousValue, item) =>
          item.totalMinutes > previousValue ? item.totalMinutes : previousValue,
    );
    return maxMinutes <= 0 ? 30 : maxMinutes + 20;
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.change});

  final double change;

  @override
  Widget build(BuildContext context) {
    if (change.isNaN || change.isInfinite) {
      return const Text(
        '—',
        style: TextStyle(
          color: _textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      );
    }
    final positive = change >= 0;
    final color = positive ? _success : _danger;
    final icon = positive ? Icons.trending_up : Icons.trending_down;
    final value = '${positive ? '+' : ''}${change.toStringAsFixed(0)}%';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
