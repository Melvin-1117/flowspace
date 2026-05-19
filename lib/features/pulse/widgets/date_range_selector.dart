import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../pulse_types.dart';
import '../providers/pulse_providers.dart';
import 'pulse_theme.dart';

class DateRangeSelector extends ConsumerWidget {
  const DateRangeSelector({
    required this.onSync,
    required this.syncing,
    super.key,
  });

  final VoidCallback onSync;
  final bool syncing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dateRangeProvider);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickDateRange(context, ref, selected),
            icon: const Icon(Icons.calendar_today, size: 16),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              backgroundColor: AppTheme.surfaceBorder,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
            ),
            label: Text(
              selected.label,
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: syncing ? null : onSync,
            style: ElevatedButton.styleFrom(
              backgroundColor: pulsePrimary,
              foregroundColor: Colors.white,
              shadowColor: pulsePrimary.withValues(alpha: 0.4),
              elevation: 10,
              minimumSize: const Size.fromHeight(44),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (syncing)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(Icons.refresh, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Sync Data',
                  style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDateRange(
    BuildContext context,
    WidgetRef ref,
    DateRange selected,
  ) async {
    final result = await showModalBottomSheet<DateRange>(
      context: context,
      backgroundColor: pulseCard,
      builder: (context) {
        var current = selected;
        return StatefulBuilder(
          builder: (context, setState) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text(
                  'Select Date Range',
                  style: GoogleFonts.spaceGrotesk(
                    color: pulseText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                for (final option in DateRange.values)
                  RadioListTile<DateRange>(
                    value: option,
                    groupValue: current,
                    activeColor: pulsePrimary,
                    title: Text(
                      option.label,
                      style: GoogleFonts.spaceGrotesk(color: pulseText),
                    ),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => current = value);
                      Navigator.of(context).pop(value);
                    },
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
    if (result == null || result == selected) return;
    ref.read(dateRangeProvider.notifier).state = result;
    ref.invalidate(contributionDataProvider);
    ref.invalidate(recentEventsProvider);
  }
}
