import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/models/analytics_models.dart';
import 'analytics_empty_state.dart';
import '../providers/analytics_providers.dart';
import '../../../app/theme.dart';

const Color _cardBackground = AppTheme.surfaceCard;
const Color _cardBorder = Color(0x0DFFFFFF);
const Color _textPrimary = AppTheme.textPrimary;
const Color _textSecondary = AppTheme.textSecondary;
const Color _intensity0 = AppTheme.surfaceElevated;
const Color _intensity1 = Color(0xFF001A3D);
const Color _intensity2 = Color(0xFF003380);
const Color _intensity3 = AppTheme.primary;
const Color _intensity4 = AppTheme.accent;
const int _rows = 7;
const int _columns = 13;
const double _cellSize = 14;
const double _cellGap = 3;

class ConsistencyArchiveHeatmap extends ConsumerWidget {
  const ConsistencyArchiveHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archive = ref.watch(consistencyArchiveProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: archive.when(
        data: (data) {
          if (data.isEmpty || data.every((item) => item.focusMinutes == 0)) {
            return const SizedBox(
              height: 140,
              child: Center(
                child: AnalyticsEmptyState(
                  message: 'Keep a daily focus streak to fill this archive.',
                  icon: Icons.calendar_month_outlined,
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Consistency Archive',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Activity density over the last 90 days',
                style: TextStyle(color: _textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 10),
              _legend(),
              const SizedBox(height: 14),
              SizedBox(
                height: _rows * (_cellSize + _cellGap),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _columns,
                  itemBuilder: (context, col) {
                    return Padding(
                      padding: const EdgeInsets.only(right: _cellGap),
                      child: Column(
                        children: List<Widget>.generate(_rows, (row) {
                          final index = col * _rows + row;
                          if (index >= data.length) {
                            return const SizedBox(
                              width: _cellSize,
                              height: _cellSize,
                            );
                          }
                          final cellData = data[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: _cellGap),
                            child: GestureDetector(
                              onTap: () => _showCellTooltip(context, cellData),
                              child: Container(
                                width: _cellSize,
                                height: _cellSize,
                                decoration: BoxDecoration(
                                  color: _colorForMinutes(
                                    cellData.focusMinutes,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (_, __) => const SizedBox(
          height: 120,
          child: Center(
            child: AnalyticsEmptyState(
              message: 'Keep a daily focus streak to fill this archive.',
              icon: Icons.calendar_month_outlined,
            ),
          ),
        ),
      ),
    );
  }

  Widget _legend() {
    final colors = <Color>[
      _intensity0,
      _intensity1,
      _intensity2,
      _intensity3,
      _intensity4,
    ];
    return Row(
      children: [
        const Text(
          'LESS',
          style: TextStyle(color: _textSecondary, fontSize: 10),
        ),
        const SizedBox(width: 8),
        ...colors.map(
          (color) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'MORE',
          style: TextStyle(color: _textSecondary, fontSize: 10),
        ),
      ],
    );
  }

  Color _colorForMinutes(int minutes) {
    if (minutes <= 0) return _intensity0;
    if (minutes < 30) return _intensity1;
    if (minutes < 60) return _intensity2;
    if (minutes < 120) return _intensity3;
    return _intensity4;
  }

  Future<void> _showCellTooltip(
    BuildContext context,
    DayActivityData day,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppTheme.surfaceBorder),
          ),
          title: Text(
            DateFormat('EEE, MMM d').format(day.date),
            style: const TextStyle(color: _textPrimary, fontSize: 14),
          ),
          content: Text(
            '${day.sessionCount} focus sessions\n${day.focusMinutes} minutes\n${day.tasksWorked} tasks worked on',
            style: const TextStyle(color: _textSecondary, fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
