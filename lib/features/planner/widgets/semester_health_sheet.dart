import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/planner_providers.dart';
import '../../../app/theme.dart';

class SemesterHealthSheet extends ConsumerWidget {
  const SemesterHealthSheet({required this.health, super.key});

  final SemesterHealth health;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trend = ref.watch(semesterHealthTrendProvider);
    final bars = [
      ('Subject Completion', health.avgCompletion, 0.4),
      ('Milestone Readiness', health.readiness, 0.3),
      ('Focus Completion', health.focusRate, 0.2),
      ('Streak Consistency', health.streakConsistency, 0.1),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Semester Health Breakdown',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              for (final (label, value, weight) in bars) ...[
                Text(
                  '$label (${(weight * 100).round()}%)',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: value.clamp(0, 1),
                  minHeight: 8,
                  backgroundColor: AppTheme.surfaceElevated,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 8),
              const Text(
                'Recommendation',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Focus more on subjects with low completion and near deadlines.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              const Text(
                '7-Day Health Trend',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: trend.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(
                    child: Text(
                      'Trend unavailable',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                  data: (points) => LineChart(
                    LineChartData(
                      minY: 0,
                      maxY: 100,
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: AppTheme.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          spots: [
                            for (var i = 0; i < points.length; i++)
                              FlSpot(i.toDouble(), points[i]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
