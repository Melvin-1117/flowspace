import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/language_cache.dart';
import '../providers/pulse_providers.dart';
import '../../../app/theme.dart';
import 'pulse_theme.dart';

class LanguageDonutChart extends ConsumerStatefulWidget {
  const LanguageDonutChart({super.key});

  @override
  ConsumerState<LanguageDonutChart> createState() => _LanguageDonutChartState();
}

class _LanguageDonutChartState extends ConsumerState<LanguageDonutChart> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(languageDistributionProvider);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: pulseCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: asyncData.when(
        data: (data) => _buildData(data),
        loading: () => const SizedBox(
          height: 240,
          child: Center(child: CircularProgressIndicator(color: pulsePrimary)),
        ),
        error: (_, __) => SizedBox(
          height: 180,
          child: Center(
            child: Text('No data', style: GoogleFonts.spaceGrotesk(color: pulseMuted)),
          ),
        ),
      ),
    );
  }

  Widget _buildData(LanguageCache data) {
    final entries = data.languages.entries.toList();
    if (entries.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text('No data', style: GoogleFonts.spaceGrotesk(color: pulseMuted)),
        ),
      );
    }
    final dominant = entries.reduce((a, b) => a.value >= b.value ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Language Distribution',
          style: GoogleFonts.spaceGrotesk(
            color: pulseText,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 170,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 44,
                  startDegreeOffset: -90,
                  sections: [
                    for (var i = 0; i < entries.length; i++)
                      PieChartSectionData(
                        value: entries[i].value,
                        color: _languageColor(entries[i].key),
                        radius: selectedIndex == i ? 52 : 44,
                        title: '',
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${dominant.value.round()}%',
                    style: GoogleFonts.spaceGrotesk(
                      color: pulseText,
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    dominant.key,
                    style: GoogleFonts.spaceGrotesk(color: pulseMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 220.ms),
        const SizedBox(height: 8),
        for (var i = 0; i < entries.length; i++)
          InkWell(
            onTap: () => setState(() => selectedIndex = i),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _languageColor(entries[i].key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entries[i].key,
                      style: GoogleFonts.spaceGrotesk(color: pulseText, fontSize: 14),
                    ),
                  ),
                  Tooltip(
                    message:
                        '${entries[i].key} — ${entries[i].value.toStringAsFixed(1)}% — ${data.repoCounts[entries[i].key] ?? 0} repos',
                    child: Text(
                      '${entries[i].value.toStringAsFixed(0)}%',
                      style: GoogleFonts.spaceGrotesk(
                        color: pulseText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Color _languageColor(String language) => switch (language.toLowerCase()) {
    'typescript' => AppTheme.primary,
    'javascript' => AppTheme.warning,
    'python' => AppTheme.accent,
    'rust' => AppTheme.danger,
    'go' => AppTheme.success,
    'dart' => AppTheme.primaryDark,
    'other' => AppTheme.textSecondary,
    _ => AppTheme.textSecondary,
  };
}
