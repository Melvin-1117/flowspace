import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Time formatting
String formatMMSS(int seconds) {
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

String formatDurationMinutes(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  if (h > 0) return '${h}h ${m}m';
  return '${m}m';
}

String formatHoursDecimal(double hours) =>
  '${hours.toStringAsFixed(1)}h';

// Date formatting
String formatRelativeTime(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24)   return '${diff.inHours}h ago';
  if (diff.inDays == 1)    return 'Yesterday';
  if (diff.inDays < 7)     return '${diff.inDays}d ago';
  return DateFormat('MMM d').format(date);
}

String formatDayMonth(DateTime date) =>
  DateFormat('EEE, MMM d').format(date);

String formatMonthYear(DateTime date) =>
  DateFormat('MMM yyyy').format(date);

bool isSameDay(DateTime a, DateTime b) =>
  a.year == b.year && a.month == b.month && a.day == b.day;

// Priority and status
Color getPriorityColor(String priority) => switch (priority) {
  'high' => const Color(0xFFFF3B5C),
  'med'  => const Color(0xFFFFB800),
  'low'  => const Color(0xFF00D4AA),
  _      => const Color(0xFF6B8CAE),
};

Color getStatusColor(String status) => switch (status) {
  'done'       => const Color(0xFF00D4AA),
  'inprogress' => const Color(0xFF006EE6),
  'todo'       => const Color(0xFF6B8CAE),
  _            => const Color(0xFF6B8CAE),
};
