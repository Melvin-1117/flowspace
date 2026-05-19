import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/analytics_models.dart';
import 'analytics_empty_state.dart';
import '../providers/analytics_providers.dart';
import 'stat_progress_bar.dart';
import '../../../app/theme.dart';

const Color _cardBackground = AppTheme.surfaceCard;
const Color _cardBorder = Color(0x0DFFFFFF);
const Color _textPrimary = AppTheme.textPrimary;
const Color _textSecondary = AppTheme.textSecondary;
const Color _cyan = AppTheme.accent;
const Color _success = AppTheme.success;
const Color _danger = AppTheme.danger;

class AvgSessionCard extends ConsumerWidget {
  const AvgSessionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(avgSessionDurationProvider);
    final targetDuration = ref.watch(analyticsTargetDurationProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showMonthlyBreakdown(context, ref),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: duration.when(
          data: (data) {
            final targetSeconds = targetDuration.valueOrNull ?? 1500;
            final progress = targetSeconds == 0
                ? 0.0
                : data.avgSeconds / targetSeconds;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _cyan.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.alarm, color: _cyan, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AVG SESSION DURATION',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                _formatDuration(data.avgSeconds),
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _changeLabel(data),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                StatProgressBar(value: progress, fillColor: _cyan),
              ],
            );
          },
          loading: () => const SizedBox(
            height: 70,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const AnalyticsEmptyState(
            message: 'Complete focus sessions to inspect duration trends.',
            icon: Icons.alarm_on_outlined,
          ),
        ),
      ),
    );
  }

  Widget _changeLabel(SessionDurationData data) {
    if (!data.hasLastYearData) {
      return const Text(
        'No data for last year',
        style: TextStyle(color: _textSecondary, fontSize: 11),
      );
    }
    final positive = data.changeSeconds >= 0;
    final absMinutes = (data.changeSeconds.abs() / 60).round();
    return Row(
      children: [
        Icon(
          positive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 12,
          color: positive ? _success : _danger,
        ),
        Text(
          '${positive ? '+' : '-'}${absMinutes}m vs LY',
          style: TextStyle(
            color: positive ? _success : _danger,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).round();
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    return '${hours}h ${remaining}m';
  }

  Future<void> _showMonthlyBreakdown(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Consumer(
        builder: (context, ref, __) {
          final duration = ref.watch(avgSessionDurationProvider);
          return duration.when(
            data: (data) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Average Session Duration',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                            drawVerticalLine: false,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (_) =>
                                const FlLine(color: AppTheme.surfaceElevated),
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
                                getTitlesWidget: (value, _) {
                                  final i = value.toInt();
                                  if (i < 0 ||
                                      i >= data.monthlyAverageSeconds.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    data.monthlyAverageSeconds[i].monthLabel,
                                    style: const TextStyle(
                                      color: _textSecondary,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: List<BarChartGroupData>.generate(
                            data.monthlyAverageSeconds.length,
                            (index) {
                              final value =
                                  data.monthlyAverageSeconds[index].seconds /
                                  60;
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: value,
                                    width: 12,
                                    color: _cyan,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
