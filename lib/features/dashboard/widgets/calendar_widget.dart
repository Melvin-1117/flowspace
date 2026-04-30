import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/calendar_providers.dart';
import 'calendar_header.dart';
import 'calendar_day_cell.dart';
import 'calendar_bottom_sheet.dart';

class DashboardCalendarWidget extends ConsumerStatefulWidget {
  const DashboardCalendarWidget({super.key});

  @override
  ConsumerState<DashboardCalendarWidget> createState() =>
      _DashboardCalendarWidgetState();
}

class _DashboardCalendarWidgetState
    extends ConsumerState<DashboardCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(ref.read(selectedDateProvider), selectedDay)) {
      ref.read(selectedDateProvider.notifier).setDate(selectedDay);
      setState(() {
        _focusedDay = focusedDay;
      });
    }

    _showDayBottomSheet(context, selectedDay);
  }

  void _showDayBottomSheet(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // Background handled by clip in bottom sheet
      builder: (context) => CalendarBottomSheet(
        date: selectedDay,
      ).animate().slideY(begin: 1, duration: 250.ms, curve: Curves.easeOutQuad),
    );
  }

  void _onTitleTap() {
    setState(() {
      _calendarFormat = _calendarFormat == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedDateProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFF1A1D27,
        ).withValues(alpha: 0.6), // Surface Card with glass effect prep
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CalendarHeader(
              focusedDay: _focusedDay,
              onTitleTap: _onTitleTap,
              onLeftChevronTap: () {
                setState(() {
                  _focusedDay = _calendarFormat == CalendarFormat.week
                      ? _focusedDay.subtract(const Duration(days: 7))
                      : DateTime(
                          _focusedDay.year,
                          _focusedDay.month - 1,
                          _focusedDay.day,
                        );
                });
              },
              onRightChevronTap: () {
                setState(() {
                  _focusedDay = _calendarFormat == CalendarFormat.week
                      ? _focusedDay.add(const Duration(days: 7))
                      : DateTime(
                          _focusedDay.year,
                          _focusedDay.month + 1,
                          _focusedDay.day,
                        );
                });
              },
            ),
            TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: _onDaySelected,
                  onDayLongPressed: (day, _) {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final selectedDate = DateTime(day.year, day.month, day.day);
                    if (!selectedDate.isBefore(today)) {
                      context.push(
                        '/tasks/add',
                        extra: day,
                      ); // Push add modal logic
                    }
                  },
                  headerVisible: false,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 11,
                    ),
                    weekendStyle: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 11,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) =>
                        GestureDetector(
                          onTap: () => _onDaySelected(day, focusedDay),
                          child: CalendarDayCell(day: day)
                              .animate()
                              .scale(
                                duration: 100.ms,
                                begin: const Offset(1, 1),
                                end: const Offset(0.95, 0.95),
                              )
                              .then()
                              .scale(end: const Offset(1, 1)),
                        ),
                    selectedBuilder: (context, day, focusedDay) =>
                        GestureDetector(
                          onTap: () => _onDaySelected(day, focusedDay),
                          child: CalendarDayCell(day: day, isSelected: true),
                        ),
                    todayBuilder: (context, day, focusedDay) => GestureDetector(
                      onTap: () => _onDaySelected(day, focusedDay),
                      child: CalendarDayCell(day: day, isToday: true),
                    ),
                    outsideBuilder: (context, day, focusedDay) =>
                        CalendarDayCell(day: day, isOutside: true),
                  ),
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                )
                .animate(
                  target: _calendarFormat == CalendarFormat.month ? 1 : 0,
                )
                .slideX(
                  begin: 0.05,
                  end: 0,
                  duration: 300.ms,
                ), // Example of month transition slide
          ],
        ),
      ),
    );
  }
}
