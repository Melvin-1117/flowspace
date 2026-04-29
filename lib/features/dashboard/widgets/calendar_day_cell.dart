import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/providers/calendar_providers.dart';

class CalendarDayCell extends ConsumerWidget {
  final DateTime day;
  final bool isToday;
  final bool isSelected;
  final bool isOutside;

  const CalendarDayCell({
    super.key,
    required this.day,
    this.isToday = false,
    this.isSelected = false,
    this.isOutside = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Heatmap background evaluation
    final sessionsAsync = ref.watch(sessionsByDateProvider(day));
    Color heatGlow = Colors.transparent;

    // Evaluate session glow
    if (sessionsAsync.hasValue && sessionsAsync.value!.isNotEmpty) {
      int count = sessionsAsync.value!.length;
      if (count <= 2) {
        heatGlow = const Color(
          0xFF7C3AED,
        ).withValues(alpha: 0.15); // Faint purple
      } else if (count <= 4) {
        heatGlow = const Color(
          0xFF7C3AED,
        ).withValues(alpha: 0.4); // Medium purple
      } else {
        heatGlow = const Color(0xFF06B6D4).withValues(alpha: 0.5); // Peak cyan
      }
    }

    // 2. Streak strip evaluation (Checking previous, current, next day from streak provider)
    final streakAsync = ref.watch(streakDaysProvider);
    bool inStreak = false;
    bool prevInStreak = false;
    bool nextInStreak = false;

    if (streakAsync.hasValue) {
      final strips = streakAsync.value!;
      inStreak = strips.any((d) => isSameDay(d, day));
      if (inStreak) {
        prevInStreak = strips.any(
          (d) => isSameDay(d, day.subtract(const Duration(days: 1))),
        );
        nextInStreak = strips.any(
          (d) => isSameDay(d, day.add(const Duration(days: 1))),
        );
      }
    }

    // 3. Task dots indicator
    final tasksAsync = ref.watch(tasksByDateProvider(day));
    List<Color> dotColors = [];
    if (tasksAsync.hasValue) {
      final tasks = tasksAsync.value!;
      final now = DateTime.now();
      for (var t in tasks) {
        if (!t.isCompleted) {
          if (t.dueDate.isBefore(now)) {
            dotColors.add(const Color(0xFFEF4444)); // Overdue context
          } else if (isSameDay(t.dueDate, now)) {
            dotColors.add(const Color(0xFF7C3AED)); // Due today
          } else {
            dotColors.add(
              const Color(0xFF06B6D4),
            ); // Due this week or future logic
          }
        }
      }
    }

    // Determine circular styling priority
    BoxDecoration? circularDeco;
    if (isSelected) {
      circularDeco = BoxDecoration(
        color: const Color(0xFF06B6D4), // Cyan for selected
        shape: BoxShape.circle,
      );
    } else if (isToday) {
      circularDeco = BoxDecoration(
        color: const Color(0xFF7C3AED), // Purple for today
        shape: BoxShape.circle,
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Streak Strip
          if (inStreak)
            Positioned(
              left: prevInStreak ? 0 : 6,
              right: nextInStreak ? 0 : 6,
              top: 8,
              bottom: 18,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.horizontal(
                    left: prevInStreak
                        ? Radius.zero
                        : const Radius.circular(20),
                    right: nextInStreak
                        ? Radius.zero
                        : const Radius.circular(20),
                  ),
                ),
              ),
            ),

          // Heatmap + Selection Circle
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(bottom: 8),
            decoration:
                circularDeco ??
                BoxDecoration(color: heatGlow, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: GoogleFonts.inter(
                color: isOutside ? const Color(0xFF6B7280) : Colors.white,
                fontSize: 12,
                fontWeight: isSelected || isToday
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ),

          // Badge Event Indicators (Mocks - requires reading studyEventProvider)

          // Dots container below number
          Positioned(
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (dotColors.length > 3)
                  Text(
                    '3+',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 8),
                  )
                else
                  ...dotColors
                      .take(3)
                      .map(
                        (color) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
