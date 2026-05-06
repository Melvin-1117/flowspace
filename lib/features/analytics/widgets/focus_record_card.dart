import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'analytics_empty_state.dart';
import '../providers/analytics_providers.dart';

const Color _cardBackground = Color(0xFF0D0D0D);
const Color _cardBorder = Color(0x0DFFFFFF);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFF555555);
const Color _purple = Color(0xFF7C3AED);
const Color _purpleSoft = Color(0x267C3AED);

class FocusRecordCard extends ConsumerWidget {
  const FocusRecordCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusRecord = ref.watch(focusRecordProvider);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showRecordDetailSheet(context, ref),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: focusRecord.when(
          data: (hours) => Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _purpleSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bolt, color: _purple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FOCUS RECORD',
                      style: TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${hours.toStringAsFixed(1)}h',
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading: () => const SizedBox(
            height: 52,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const _EmptyAnalyticsState(),
        ),
      ),
    );
  }

  Future<void> _showRecordDetailSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => Consumer(
        builder: (context, ref, __) {
          final detail = ref.watch(focusRecordDetailProvider);
          return detail.when(
            data: (data) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Focus Record Detail',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.recordDate == null
                          ? 'No record yet'
                          : DateFormat('EEE, MMM d').format(data.recordDate!),
                      style: const TextStyle(color: _textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: ${(data.totalSeconds / 3600).toStringAsFixed(1)}h • ${data.sessionCount} sessions • ${data.tasksWorked} tasks',
                      style: const TextStyle(color: _textPrimary),
                    ),
                    const SizedBox(height: 12),
                    if (data.sessions.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: _EmptyAnalyticsState(),
                      )
                    else
                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            final session = data.sessions[index];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    session.taskTitle?.isNotEmpty == true
                                        ? session.taskTitle!
                                        : DateFormat(
                                            'hh:mm a',
                                          ).format(session.startTime),
                                    style: const TextStyle(color: _textPrimary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${(session.durationSeconds / 60).round()}m',
                                  style: const TextStyle(color: _textSecondary),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const Divider(color: _cardBorder),
                          itemCount: data.sessions.length,
                        ),
                      ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) =>
                const SizedBox(height: 120, child: _EmptyAnalyticsState()),
          );
        },
      ),
    );
  }
}

class _EmptyAnalyticsState extends StatelessWidget {
  const _EmptyAnalyticsState();

  @override
  Widget build(BuildContext context) {
    return const AnalyticsEmptyState(
      message: 'Complete focus sessions to surface your best day.',
      icon: Icons.bolt_outlined,
    );
  }
}
