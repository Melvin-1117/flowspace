class AnalyticsPayload {
  final String sourceScreen;
  final DateTime focusDate;
  final int totalFocusMinutes;
  final int completedSessions;
  final int abandonedSessions;
  final List<String> linkedTaskIds;

  const AnalyticsPayload({
    required this.sourceScreen,
    required this.focusDate,
    required this.totalFocusMinutes,
    required this.completedSessions,
    required this.abandonedSessions,
    required this.linkedTaskIds,
  });
}
