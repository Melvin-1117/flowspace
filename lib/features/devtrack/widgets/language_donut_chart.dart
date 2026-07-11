import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/devtrack_providers.dart';

class LanguageDonutChart extends ConsumerStatefulWidget {
  const LanguageDonutChart({super.key});

  @override
  ConsumerState<LanguageDonutChart> createState() => _LanguageDonutChartState();
}

class _LanguageDonutChartState extends ConsumerState<LanguageDonutChart> {
  int _touchedIndex = -1;

  static const Map<String, Color> _languageColors = {
    'Dart': Color(0xFF006EE6),
    'Flutter': Color(0xFF00B4FF),
    'Python': Color(0xFFFFB800),
    'JavaScript': Color(0xFFFFD600),
    'TypeScript': Color(0xFF3178C6),
    'HTML': Color(0xFFE34F26),
    'CSS': Color(0xFF1572B6),
    'C++': Color(0xFF00599C),
    'C#': Color(0xFF239120),
    'Java': Color(0xFFB07219),
    'Kotlin': Color(0xFF7F52FF),
    'Swift': Color(0xFFF05138),
    'Go': Color(0xFF00ADD8),
    'Rust': Color(0xFFDEA584),
  };

  Color _getColorForLanguage(String language) {
    if (_languageColors.containsKey(language)) {
      return _languageColors[language]!;
    }
    // Generate a deterministic color based on hashcode
    final hash = language.hashCode;
    return Color(0xFF000000 | (hash & 0xFFFFFF)).withValues(alpha: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final distributionAsync = ref.watch(devtrackLanguageDistributionProvider);

    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LANGUAGES USED',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          distributionAsync.when(
            data: (data) {
              if (data.isEmpty) {
                return SizedBox(
                  height: 160,
                  child: Center(
                    child: Text(
                      'No language data logged yet.',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),
                );
              }

              final sortedEntries = data.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 140,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 3,
                          centerSpaceRadius: 36,
                          sections: sortedEntries.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final e = entry.value;
                            final isTouched = idx == _touchedIndex;
                            final radius = isTouched ? 28.0 : 22.0;

                            return PieChartSectionData(
                              color: _getColorForLanguage(e.key),
                              value: e.value,
                              title: isTouched ? '${e.value.toStringAsFixed(1)}%' : '',
                              radius: radius,
                              titleStyle: GoogleFonts.spaceGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMD),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: sortedEntries.take(4).map((e) {
                        final color = _getColorForLanguage(e.key);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  e.key,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textPrimary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${e.value.toStringAsFixed(1)}%',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(
              height: 140,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (err, stack) => SizedBox(
              height: 140,
              child: Center(
                child: Text(
                  'Error loading languages.',
                  style: GoogleFonts.spaceGrotesk(color: AppTheme.danger),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
