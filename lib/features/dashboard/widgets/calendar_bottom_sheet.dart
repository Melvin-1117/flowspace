import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/calendar_providers.dart';
import 'calendar_task_card.dart';

class CalendarBottomSheet extends ConsumerWidget {
  final DateTime date;

  const CalendarBottomSheet({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksByDateProvider(date));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isPast = DateTime(date.year, date.month, date.day).isBefore(today);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D27).withValues(alpha: 0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B7280),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                DateFormat('EEEE, MMMM d').format(date),
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              tasksAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          isPast ? "No tasks" : "No tasks — add one?",
                          style: GoogleFonts.inter(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) =>
                        CalendarTaskCard(task: tasks[index]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              if (!isPast) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Requires GoRouter setup upstream
                      context.push('/tasks/add', extra: date);
                    },
                    child: Text(
                      'Add Task for this day',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
