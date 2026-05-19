import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/task.dart';
import '../../../app/theme.dart';

class ProgressBreakdownSheet extends StatelessWidget {
  const ProgressBreakdownSheet({
    super.key,
    required this.tasks,
    required this.progress,
  });

  final List<Task> tasks;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final todo = tasks.where((task) => task.status == 'todo').length.toDouble();
    final inProgress = tasks
        .where((task) => task.status == 'inprogress')
        .length
        .toDouble();
    final done = tasks.where((task) => task.status == 'done').length.toDouble();
    final total = tasks.length;
    final remaining = total - done.toInt();
    final date = DateFormat(
      'MMM d, y',
    ).format(DateTime.now().add(Duration(days: remaining + 1)));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Progress Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 45,
                  sections: [
                    PieChartSectionData(
                      value: todo,
                      color: AppTheme.textSecondary,
                      title: 'To Do',
                    ),
                    PieChartSectionData(
                      value: inProgress,
                      color: AppTheme.accent,
                      title: 'In Progress',
                    ),
                    PieChartSectionData(
                      value: done,
                      color: AppTheme.success,
                      title: 'Done',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Progress ${(progress * 100).round()}%'),
            const SizedBox(height: 8),
            Text(
              'Estimated completion: $date',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
