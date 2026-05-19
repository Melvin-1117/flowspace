import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/models/contribution_cache.dart';
import '../pulse_types.dart';
import '../providers/pulse_providers.dart';
import '../../../app/theme.dart';
import 'pulse_theme.dart';

class ContributionHeatmap extends ConsumerWidget {
  const ContributionHeatmap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(dateRangeProvider);
    final data = ref.watch(contributionDataProvider);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: pulseCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: data.when(
        data: (value) => _Content(data: value, range: range),
        error: (_, __) => _ErrorState(
          message: 'Could not load contributions',
          onRetry: () => ref.invalidate(contributionDataProvider),
        ),
        loading: () => const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator(color: pulsePrimary)),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.data, required this.range});

  final ContributionData data;
  final DateRange range;

  @override
  Widget build(BuildContext context) {
    final weeks = _normalizeWeeks(data.weeks);
    final total = data.totalContributions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contribution Activity',
          style: GoogleFonts.spaceGrotesk(
            color: pulseText,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$total contributions in the last ${range.days >= 365 ? 'year' : '${range.days} days'}',
          style: GoogleFonts.spaceGrotesk(color: pulseMuted, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              'Less',
              style: GoogleFonts.spaceGrotesk(color: pulseMuted, fontSize: 10),
            ),
            const SizedBox(width: 6),
            const _LegendCell(color: AppTheme.surfaceElevated),
            const _LegendCell(color: Color(0xFF001A3D)),
            const _LegendCell(color: Color(0xFF003380)),
            const _LegendCell(color: AppTheme.primary),
            const _LegendCell(color: AppTheme.accent),
            const SizedBox(width: 6),
            Text(
              'More',
              style: GoogleFonts.spaceGrotesk(color: pulseMuted, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final week in weeks)
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Column(
                    children: [
                      for (final day in week)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            waitDuration: Duration.zero,
                            showDuration: const Duration(seconds: 2),
                            preferBelow: false,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceElevated,
                              border: Border.all(
                                color: AppTheme.surfaceBorder,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            message: day.contributionCount == 0
                                ? 'No contributions on ${DateFormat.yMMMd().format(day.date)}'
                                : '${day.contributionCount} contributions on ${DateFormat.yMMMd().format(day.date)}',
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _colorForCount(day.contributionCount),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms),
      ],
    );
  }

  List<List<ContributionDay>> _normalizeWeeks(List<List<ContributionDay>> raw) {
    final now = DateTime.now();
    if (raw.isEmpty) {
      final start = now.subtract(const Duration(days: 364));
      return List.generate(
        52,
        (w) => List.generate(
          7,
          (d) => ContributionDay(
            date: start.add(Duration(days: (w * 7) + d)),
            contributionCount: 0,
          ),
        ),
      );
    }
    final normalized = [...raw];
    if (normalized.length > 52) {
      return normalized.sublist(normalized.length - 52);
    }
    while (normalized.length < 52) {
      final seed = normalized.isNotEmpty
          ? normalized.first.first.date.subtract(const Duration(days: 7))
          : now.subtract(const Duration(days: 364));
      normalized.insert(
        0,
        List.generate(
          7,
          (index) => ContributionDay(
            date: seed.add(Duration(days: index)),
            contributionCount: 0,
          ),
        ),
      );
    }
    return normalized;
  }

  Color _colorForCount(int count) {
    if (count == 0) return AppTheme.surfaceElevated;
    if (count <= 3) return const Color(0xFF001A3D);
    if (count <= 6) return const Color(0xFF003380);
    if (count <= 9) return AppTheme.primary;
    return AppTheme.accent;
  }
}

class _LegendCell extends StatelessWidget {
  const _LegendCell({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: GoogleFonts.spaceGrotesk(color: pulseMuted)),
            const SizedBox(height: 10),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
