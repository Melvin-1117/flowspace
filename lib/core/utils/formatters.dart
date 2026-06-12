import 'package:intl/intl.dart';

/// Unifies relative timestamp text formatting.
String formatRelativeTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else {
    return DateFormat('MMM d, h:mm a').format(time);
  }
}

/// Formats total seconds to a 'MM:SS' pattern.
String formatDurationMmSs(int totalSeconds) {
  final m = totalSeconds ~/ 60;
  final s = totalSeconds % 60;
  return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
}

/// Formats minutes into a user-friendly 'Xh Ym' or 'Xm' representation.
String formatDurationMinutes(int minutes, {bool showZeroMinutes = true}) {
  if (minutes < 60) return '${minutes}m';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  if (m == 0 && !showZeroMinutes) {
    return '${h}h';
  }
  return '${h}h ${m}m';
}
