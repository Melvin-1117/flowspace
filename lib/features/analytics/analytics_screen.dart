import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../pomodoro/providers/pomodoro_providers.dart';
import 'analytics_payload.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({this.payload, super.key});

  final AnalyticsPayload? payload;

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  bool _showBanner = true;

  @override
  Widget build(BuildContext context) {
    final payload = widget.payload;
    final today = payload?.focusDate ?? DateTime.now();
    final dayLabel = DateFormat('EEE, MMM d').format(today);
    final sessions = ref.watch(todaySessionsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        title: const Text('Analytics'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (payload != null && _showBanner)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0x337C3AED)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Showing stats for today's focus session",
                      style: TextStyle(color: Color(0xFFF0F0F0)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _showBanner = false),
                    icon: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Focus date: $dayLabel',
                  style: const TextStyle(
                    color: Color(0xFFF0F0F0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Total focus minutes: ${payload?.totalFocusMinutes ?? 0}',
                  style: const TextStyle(color: Color(0xFFB2B2B7)),
                ),
                Text(
                  'Completed sessions: ${payload?.completedSessions ?? 0}',
                  style: const TextStyle(color: Color(0xFFB2B2B7)),
                ),
                Text(
                  'Abandoned sessions: ${payload?.abandonedSessions ?? 0}',
                  style: const TextStyle(color: Color(0xFFB2B2B7)),
                ),
                Text(
                  'Linked tasks: ${(payload?.linkedTaskIds.length ?? 0)}',
                  style: const TextStyle(color: Color(0xFFB2B2B7)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          sessions.when(
            data: (items) => Text(
              'Loaded ${items.length} sessions for today.',
              style: const TextStyle(color: Color(0xFF555555)),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text(
              'Failed to load today sessions',
              style: TextStyle(color: Color(0xFF555555)),
            ),
          ),
        ],
      ),
    );
  }
}
