import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../analytics_payload.dart';

const Color _bannerBorder = Color(0xFF7C3AED);
const Color _bannerBackground = Color(0x1A7C3AED);
const Color _bannerText = Color(0xFFF0F0F0);

class AnalyticsBanner extends StatelessWidget {
  const AnalyticsBanner({
    required this.payload,
    required this.onDismiss,
    super.key,
  });

  final AnalyticsPayload payload;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final focusDate = payload.focusDate;
    final isToday =
        today.year == focusDate.year &&
        today.month == focusDate.month &&
        today.day == focusDate.day;
    final message = isToday
        ? "Showing stats for today's focus session"
        : 'Showing stats for ${DateFormat('MMM d').format(focusDate)}';

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _bannerBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _bannerBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: _bannerText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onDismiss,
            icon: const Icon(Icons.close, color: _bannerText, size: 16),
          ),
        ],
      ),
    );
  }
}
