/// Helper class for the 90-day activity heatmap.
class DayActivityData {
  const DayActivityData({
    required this.date,
    required this.codingMinutes,
    required this.pomodoroCount,
    required this.sessionCount,
  });

  final DateTime date;
  final int codingMinutes;
  final int pomodoroCount;
  final int sessionCount;
}
