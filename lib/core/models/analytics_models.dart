class DayVelocity {
  const DayVelocity({
    required this.weekday,
    required this.sessionCount,
    required this.totalMinutes,
    required this.isToday,
  });

  final int weekday;
  final int sessionCount;
  final int totalMinutes;
  final bool isToday;
}

class DayActivityData {
  const DayActivityData({
    required this.date,
    required this.focusMinutes,
    required this.sessionCount,
    required this.tasksWorked,
  });

  final DateTime date;
  final int focusMinutes;
  final int sessionCount;
  final int tasksWorked;
}

class AllocationData {
  const AllocationData({
    required this.deepWorkPercent,
    required this.operationsPercent,
    required this.planningPercent,
    required this.optimizedPercent,
    required this.categoryHours,
  });

  final double deepWorkPercent;
  final double operationsPercent;
  final double planningPercent;
  final double optimizedPercent;
  final Map<String, double> categoryHours;
}

class SessionDurationData {
  const SessionDurationData({
    required this.avgSeconds,
    required this.changeSeconds,
    required this.hasLastYearData,
    required this.monthlyAverageSeconds,
  });

  final int avgSeconds;
  final int changeSeconds;
  final bool hasLastYearData;
  final List<MonthlyDurationPoint> monthlyAverageSeconds;
}

class MonthlyDurationPoint {
  const MonthlyDurationPoint({required this.monthLabel, required this.seconds});

  final String monthLabel;
  final int seconds;
}

class TaskCompletionData {
  const TaskCompletionData({
    required this.ratio,
    required this.thisMonthCompleted,
    required this.lastMonthCompleted,
    required this.changePercent,
    required this.totalTasks,
    required this.completedTasks,
    required this.weeklyTrend,
  });

  final double ratio;
  final int thisMonthCompleted;
  final int lastMonthCompleted;
  final double changePercent;
  final int totalTasks;
  final int completedTasks;
  final List<WeeklyCompletionPoint> weeklyTrend;
}

class WeeklyCompletionPoint {
  const WeeklyCompletionPoint({required this.weekLabel, required this.ratio});

  final String weekLabel;
  final double ratio;
}

class FocusRecordSession {
  const FocusRecordSession({
    required this.startTime,
    required this.durationSeconds,
    required this.taskTitle,
  });

  final DateTime startTime;
  final int durationSeconds;
  final String? taskTitle;
}

class FocusRecordDetail {
  const FocusRecordDetail({
    required this.recordDate,
    required this.totalSeconds,
    required this.sessionCount,
    required this.tasksWorked,
    required this.sessions,
  });

  final DateTime? recordDate;
  final int totalSeconds;
  final int sessionCount;
  final int tasksWorked;
  final List<FocusRecordSession> sessions;
}
