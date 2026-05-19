import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class MilestoneCountdown extends StatelessWidget {
  const MilestoneCountdown({required this.remaining, super.key});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24).abs();
    final mins = remaining.inMinutes.remainder(60).abs();
    return Row(
      children: [
        Expanded(child: _cell('$days', 'DAYS')),
        const SizedBox(width: 8),
        Expanded(child: _cell('$hours', 'HOURS')),
        const SizedBox(width: 8),
        Expanded(child: _cell('$mins', 'MINS')),
      ],
    );
  }

  Widget _cell(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        border: Border.all(color: AppTheme.surfaceBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
