import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/animation_tokens.dart';
import '../../../core/models/analytics_models.dart';
import 'analytics_empty_state.dart';
import '../providers/analytics_providers.dart';

const Color _cardBackground = Color(0xFF0D0D0D);
const Color _cardBorder = Color(0x0DFFFFFF);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFF555555);
const Color _deepWorkColor = Color(0xFF7C3AED);
const Color _operationsColor = Color(0xFF06B6D4);
const Color _planningColor = Color(0xFF555555);
const Color _remainingColor = Color(0xFF1A1A1A);

class AllocationDonutChart extends ConsumerStatefulWidget {
  const AllocationDonutChart({super.key});

  @override
  ConsumerState<AllocationDonutChart> createState() =>
      _AllocationDonutChartState();
}

class _AllocationDonutChartState extends ConsumerState<AllocationDonutChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final allocationData = ref.watch(allocationProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: allocationData.when(
        data: (data) {
          if (_isEmpty(data)) {
                return const SizedBox(
                  height: 140,
                  child: Center(
                    child: AnalyticsEmptyState(
                      message: 'Run focused sessions to see time allocation.',
                      icon: Icons.pie_chart_outline_rounded,
                    ),
                  ),
            );
          }
          final remaining =
              (100 -
                      data.deepWorkPercent -
                      data.operationsPercent -
                      data.planningPercent)
                  .clamp(0.0, 100.0);
          final sections = _buildSections(data, remaining);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Allocation',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: kChartDuration,
                      curve: kChartCurve,
                      builder: (_, progress, __) {
                        return PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 46,
                            startDegreeOffset: -90,
                            pieTouchData: PieTouchData(
                              touchCallback: (event, response) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      response == null ||
                                      response.touchedSection == null) {
                                    _touchedIndex = -1;
                                  } else {
                                    _touchedIndex = response
                                        .touchedSection!
                                        .touchedSectionIndex;
                                  }
                                });
                              },
                            ),
                            sections: sections
                                .map((section) => section.copyWith(
                                      value: section.value * progress,
                                    ))
                                .toList(),
                          ),
                        );
                      },
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${data.optimizedPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: _textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            'OPTIMIZED',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 11,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_touchedIndex >= 0 && _touchedIndex < 3)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _sliceTooltip(data, _touchedIndex),
                    style: const TextStyle(color: _textSecondary, fontSize: 12),
                  ),
                ),
              _legendRow('Deep Work', data.deepWorkPercent, _deepWorkColor),
              const SizedBox(height: 10),
              _legendRow(
                'Operations',
                data.operationsPercent,
                _operationsColor,
              ),
              const SizedBox(height: 10),
              _legendRow('Planning', data.planningPercent, _planningColor),
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
              message: 'Run focused sessions to see time allocation.',
              icon: Icons.pie_chart_outline_rounded,
            ),
          ),
        ),
      ),
    );
  }

  bool _isEmpty(AllocationData data) {
    return data.deepWorkPercent <= 0 &&
        data.operationsPercent <= 0 &&
        data.planningPercent <= 0;
  }

  List<PieChartSectionData> _buildSections(
    AllocationData data,
    double remaining,
  ) {
    return [
      _section(data.deepWorkPercent, _deepWorkColor, 0),
      _section(data.operationsPercent, _operationsColor, 1),
      _section(data.planningPercent, _planningColor, 2),
      _section(remaining, _remainingColor, 3),
    ];
  }

  PieChartSectionData _section(double value, Color color, int index) {
    final touched = _touchedIndex == index;
    return PieChartSectionData(
      color: color,
      value: value,
      showTitle: false,
      radius: touched ? 66 : 60,
    );
  }

  String _sliceTooltip(AllocationData data, int index) {
    final names = <String>['Deep Work', 'Operations', 'Planning'];
    final percents = <double>[
      data.deepWorkPercent,
      data.operationsPercent,
      data.planningPercent,
    ];
    final hours = <double>[
      data.categoryHours['Deep Work'] ?? 0,
      data.categoryHours['Operations'] ?? 0,
      data.categoryHours['Planning'] ?? 0,
    ];
    return '${names[index]}: ${percents[index].toStringAsFixed(0)}% (${hours[index].toStringAsFixed(1)}h this week)';
  }

  Widget _legendRow(String label, double value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _textPrimary, fontSize: 14),
          ),
        ),
        Text(
          '${value.toStringAsFixed(0)}%',
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
