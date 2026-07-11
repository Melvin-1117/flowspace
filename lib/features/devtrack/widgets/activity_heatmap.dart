import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../models/day_activity_data.dart';
import '../providers/devtrack_providers.dart';

class ActivityHeatmap extends ConsumerStatefulWidget {
  const ActivityHeatmap({super.key});

  @override
  ConsumerState<ActivityHeatmap> createState() => _ActivityHeatmapState();
}

class _ActivityHeatmapState extends ConsumerState<ActivityHeatmap> {
  DayActivityData? _selectedDay;

  Color _getCellColor(int minutes) {
    if (minutes == 0) return AppTheme.surfaceElevated;
    if (minutes <= 30) return AppTheme.primary.withValues(alpha: 0.25);
    if (minutes <= 90) return AppTheme.primary.withValues(alpha: 0.5);
    if (minutes <= 180) return AppTheme.primary.withValues(alpha: 0.75);
    return AppTheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(activityHeatmapProvider);

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVITY HEATMAP (90 DAYS)',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              if (_selectedDay != null)
                Text(
                  '${DateFormat('MMM d').format(_selectedDay!.date)}: ${_selectedDay!.codingMinutes}m coded',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryLight,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),
          heatmapAsync.when(
            data: (data) {
              if (data.isEmpty) {
                return SizedBox(
                  height: 120,
                  child: Center(
                    child: Text(
                      'No activity recorded yet.',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                );
              }

              // To align weekdays, let's pad the start so the first day matches its weekday.
              // weekday: 1 (Mon) - 7 (Sun). Let's align rows so Monday is Row 0.
              final firstDate = data.first.date;
              final paddingCount = firstDate.weekday - 1; // 0 for Mon, 6 for Sun
              final totalCells = data.length + paddingCount;

              return Column(
                children: [
                  SizedBox(
                    height: 110,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                      ),
                      itemCount: totalCells,
                      itemBuilder: (context, index) {
                        if (index < paddingCount) {
                          return const SizedBox.shrink(); // Empty padding cell
                        }

                        final dayData = data[index - paddingCount];
                        final isSelected = _selectedDay?.date.year == dayData.date.year &&
                            _selectedDay?.date.month == dayData.date.month &&
                            _selectedDay?.date.day == dayData.date.day;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDay = isSelected ? null : dayData;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getCellColor(dayData.codingMinutes),
                              borderRadius: BorderRadius.circular(2),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 1.2)
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Less',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      _buildLegendCell(0),
                      const SizedBox(width: 2),
                      _buildLegendCell(20),
                      const SizedBox(width: 2),
                      _buildLegendCell(60),
                      const SizedBox(width: 2),
                      _buildLegendCell(120),
                      const SizedBox(width: 2),
                      _buildLegendCell(200),
                      const SizedBox(width: 4),
                      Text(
                        'More',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (err, stack) => SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  'Error loading activity heatmap.',
                  style: GoogleFonts.spaceGrotesk(color: AppTheme.danger),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCell(int minutes) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: _getCellColor(minutes),
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }
}
