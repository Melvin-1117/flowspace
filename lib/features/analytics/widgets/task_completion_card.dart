import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/analytics_models.dart';
import 'analytics_empty_state.dart';
import '../providers/analytics_providers.dart';
import 'stat_progress_bar.dart';

const Color _cardBackground = Color(0xFF0D0D0D);
const Color _cardBorder = Color(0x0DFFFFFF);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFF555555);
const Color _purple = Color(0xFF7C3AED);
const Color _cyan = Color(0xFF06B6D4);
const Color _success = Color(0xFF10B981);
const Color _danger = Color(0xFFEF4444);

class TaskCompletionCard extends ConsumerWidget {
  const TaskCompletionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskCompletion = ref.watch(taskCompletionProvider);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showCompletionTrend(context, ref),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: taskCompletion.when(
          data: (data) {
            final percent = (data.ratio * 100).round();
            final progressColor = percent == 100 ? _cyan : _purple;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _purple.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: _purple,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TASK COMPLETION RATIO',
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
                                '$percent%',
                                style: const TextStyle(
                                  color: _textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _changeBadge(data),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                StatProgressBar(value: data.ratio, fillColor: progressColor),
              ],
            );
          },
          loading: () => const SizedBox(
            height: 70,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const AnalyticsEmptyState(
            message: 'Finish tasks to unlock completion trend insights.',
            icon: Icons.task_alt_outlined,
          ),
        ),
      ),
    );
  }

  Widget _changeBadge(TaskCompletionData data) {
    final ratioPercent = (data.ratio * 100).round();
    if (ratioPercent == 100 && data.totalTasks > 0) {
      return const Text(
        'Perfect Score 🎯',
        style: TextStyle(
          color: _success,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    final change = data.changePercent;
    final positive = change >= 0;
    final trendLabel = change > 10 ? 'spike' : (change < -10 ? 'dip' : '');
    final prefix = positive ? '+' : '';
    return Text(
      '$prefix${change.toStringAsFixed(0)}% ${trendLabel.isEmpty ? '' : trendLabel}',
      style: TextStyle(
        color: positive ? _success : _danger,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Future<void> _showCompletionTrend(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Consumer(
        builder: (context, ref, __) {
          final data = ref.watch(taskCompletionProvider);
          return data.when(
            data: (value) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Completion Trend',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: LineChart(
                        LineChartData(
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(
                            drawVerticalLine: false,
                            horizontalInterval: 0.25,
                            getDrawingHorizontalLine: (_) =>
                                const FlLine(color: Color(0xFF1A1A1A)),
                          ),
                          minY: 0,
                          maxY: 1,
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
                                getTitlesWidget: (x, _) {
                                  final i = x.toInt();
                                  if (i < 0 || i >= value.weeklyTrend.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                    value.weeklyTrend[i].weekLabel,
                                    style: const TextStyle(
                                      color: _textSecondary,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              isCurved: true,
                              color: _purple,
                              barWidth: 3,
                              spots: List<FlSpot>.generate(
                                value.weeklyTrend.length,
                                (index) => FlSpot(
                                  index.toDouble(),
                                  value.weeklyTrend[index].ratio,
                                ),
                              ),
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
