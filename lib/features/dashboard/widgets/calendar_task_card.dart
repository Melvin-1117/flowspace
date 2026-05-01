import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/task.dart';
import '../../../core/providers/calendar_providers.dart';

class CalendarTaskCard extends ConsumerWidget {
  final Task task;

  const CalendarTaskCard({super.key, required this.task});

  Color _getPriorityColor() {
    switch (task.priority.toLowerCase()) {
      case 'urgent':
        return const Color(0xFFEF4444); // Danger
      case 'normal':
        return const Color(0xFF7C3AED); // Primary
      default:
        return const Color(0xFF06B6D4); // Accent
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0x661D1A24), // Glass card look
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: _getPriorityColor(),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(10),
              ),
            ),
          ),
          // Checkbox logic
          Checkbox(
            value: task.isCompleted,
            activeColor: const Color(0xFF7C3AED),
            checkColor: Colors.white,
            side: const BorderSide(color: Color(0xFF6B7280)),
            onChanged: (bool? value) {
              if (value != null) {
                ref
                    .read(taskCompletionProvider.notifier)
                    .toggleTask(task, value);
              }
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          task.priority.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: _getPriorityColor(),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1D27),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          task.tag.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: const Color(0xFF6B7280),
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.title,
                    style: GoogleFonts.inter(
                      color: task.isCompleted
                          ? const Color(0xFF6B7280)
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
