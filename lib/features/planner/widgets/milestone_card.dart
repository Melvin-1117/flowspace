import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/milestone.dart';

class MilestoneCard extends StatelessWidget {
  const MilestoneCard({
    required this.milestone,
    required this.countdown,
    required this.onAddMilestone,
    required this.onTap,
    super.key,
  });

  final Milestone? milestone;
  final Duration? countdown;
  final VoidCallback onAddMilestone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (milestone == null) {
      return _emptyCard();
    }
    final remaining =
        countdown ?? milestone!.dueDate.difference(DateTime.now());
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24).abs();
    final mins = remaining.inMinutes.remainder(60).abs();
    final priority = _priorityLabel(days);
    final borderColor = _priorityColor(days);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x0D06B6D4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NEXT CRITICAL MILESTONE',
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    milestone!.title,
                    style: const TextStyle(
                      color: Color(0xFFF0F0F0),
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.12),
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                      color: borderColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _countBox('$days', 'DAYS')),
                const SizedBox(width: 8),
                Expanded(child: _countBox('$hours', 'HOURS')),
                const SizedBox(width: 8),
                Expanded(child: _countBox('$mins', 'MINS')),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Due ${DateFormat.yMMMd().add_jm().format(milestone!.dueDate)}',
              style: const TextStyle(color: Color(0xFF555555), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0DFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No upcoming milestones — add one to stay on track',
            style: TextStyle(
              color: Color(0xFFF0F0F0),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onAddMilestone,
            child: const Text('Add Milestone'),
          ),
        ],
      ),
    );
  }

  Widget _countBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF262626)),
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
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 10,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

String _priorityLabel(int daysRemaining) {
  if (daysRemaining <= 3) return 'CRITICAL';
  if (daysRemaining <= 7) return 'HIGH PRIORITY';
  if (daysRemaining <= 14) return 'MEDIUM';
  return 'UPCOMING';
}

Color _priorityColor(int daysRemaining) {
  if (daysRemaining <= 3) return const Color(0xFFEF4444);
  if (daysRemaining <= 7) return const Color(0xFF06B6D4);
  if (daysRemaining <= 14) return const Color(0xFFF59E0B);
  return const Color(0xFF262626);
}
