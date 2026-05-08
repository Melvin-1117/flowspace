import 'package:flutter/material.dart';

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
        color: const Color(0xFF1A1A1A),
        border: Border.all(color: const Color(0xFF262626)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF0F0F0),
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF555555), fontSize: 10),
          ),
        ],
      ),
    );
  }
}
