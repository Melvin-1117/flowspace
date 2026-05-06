import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/models/analytics_models.dart';
import '../../../core/models/focus_goal_settings.dart';
import '../../../core/models/pomodoro_session.dart';
import '../../../core/models/task.dart';
import '../../../core/providers/isar_provider.dart';
import '../../pomodoro/providers/pomodoro_web_store.dart';
import '../../tasks/providers/task_providers.dart';
import '../analytics_payload.dart';

const int _daysInWeek = 7;
const int _archiveDays = 90;
const int _aggregationThreshold = 30;
const int _secondsPerHour = 3600;
const int _secondsPerMinute = 60;
const List<String> _deepWorkTags = <String>['frontend', 'backend'];
const List<String> _operationsTags = <String>['testing', 'devops'];
const List<String> _planningTags = <String>['research', 'planning'];

final analyticsBannerPayloadProvider = StateProvider<AnalyticsPayload?>(
  (_) => null,
);

/// Controls transient visibility of the top payload banner.
class AnalyticsBannerNotifier extends StateNotifier<bool> {
  AnalyticsBannerNotifier() : super(false);

  void show(AnalyticsPayload payload, WidgetRef ref) {
    ref.read(analyticsBannerPayloadProvider.notifier).state = payload;
    state = true;
  }

  void dismiss() => state = false;
}

final analyticsBannerProvider =
    StateNotifierProvider<AnalyticsBannerNotifier, bool>(
      (_) => AnalyticsBannerNotifier(),
    );

/// Calculates max focus hours accumulated in a single day.
final focusRecordProvider = FutureProvider<double>((ref) async {
  final sessions = await _loadFocusCompletedSessions(ref);
  if (sessions.isEmpty) return 0;
  final raw = _sessionRawRows(sessions);
  if (raw.length > _aggregationThreshold) {
    return compute(_computeFocusRecordHours, raw);
  }
  return _computeFocusRecordHours(raw);
});

/// Loads detail info for the day containing the highest focus total.
final focusRecordDetailProvider = FutureProvider<FocusRecordDetail>((
  ref,
) async {
  final sessions = await _loadFocusCompletedSessions(ref);
  if (sessions.isEmpty) {
    return const FocusRecordDetail(
      recordDate: null,
      totalSeconds: 0,
      sessionCount: 0,
      tasksWorked: 0,
      sessions: <FocusRecordSession>[],
    );
  }
  final grouped = <String, List<PomodoroSession>>{};
  for (final session in sessions) {
    final key = DateFormat('yyyy-MM-dd').format(session.startTime);
    grouped.putIfAbsent(key, () => <PomodoroSession>[]).add(session);
  }
  String bestKey = grouped.keys.first;
  int bestSeconds = 0;
  grouped.forEach((key, values) {
    final total = values.fold<int>(
      0,
      (sum, item) => sum + item.actualDurationSeconds,
    );
    if (total > bestSeconds) {
      bestSeconds = total;
      bestKey = key;
    }
  });

  final daySessions = <PomodoroSession>[...grouped[bestKey]!]
    ..sort((a, b) => b.startTime.compareTo(a.startTime));
  final tasksWorked = daySessions
      .where((s) => (s.linkedTaskId ?? '').isNotEmpty)
      .map((s) => s.linkedTaskId!)
      .toSet()
      .length;

  return FocusRecordDetail(
    recordDate: daySessions.first.startTime,
    totalSeconds: bestSeconds,
    sessionCount: daySessions.length,
    tasksWorked: tasksWorked,
    sessions: daySessions
        .map(
          (session) => FocusRecordSession(
            startTime: session.startTime,
            durationSeconds: session.actualDurationSeconds,
            taskTitle: session.linkedTaskTitle,
          ),
        )
        .toList(),
  );
});

/// Returns current-week focus minutes/session count for Mon..Sun.
final weeklyVelocityProvider = FutureProvider<List<DayVelocity>>((ref) async {
  final now = DateTime.now();
  final weekStart = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: now.weekday - 1));
  final weekEnd = weekStart.add(const Duration(days: _daysInWeek));
  final sessions = await _loadFocusCompletedSessionsInRange(
    ref,
    weekStart,
    weekEnd,
  );
  final raw = _sessionRawRows(sessions);
  if (raw.length > _aggregationThreshold) {
    final rows = await compute(_computeWeeklyVelocityRows, <String, Object>{
      'sessions': raw,
      'nowMs': now.millisecondsSinceEpoch,
      'weekStartMs': weekStart.millisecondsSinceEpoch,
    });
    return rows
        .map(
          (row) => DayVelocity(
            weekday: row['weekday']! as int,
            sessionCount: row['sessionCount']! as int,
            totalMinutes: row['totalMinutes']! as int,
            isToday: row['isToday']! as bool,
          ),
        )
        .toList();
  }
  return _computeWeeklyVelocity(rows: raw, now: now, weekStart: weekStart);
});

/// Calculates this-week vs last-week focus minutes percentage.
final velocityChangeProvider = FutureProvider<double>((ref) async {
  final now = DateTime.now();
  final thisWeekStart = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: now.weekday - 1));
  final lastWeekStart = thisWeekStart.subtract(
    const Duration(days: _daysInWeek),
  );
  final thisWeekEnd = thisWeekStart.add(const Duration(days: _daysInWeek));
  final all = await _loadFocusCompletedSessionsInRange(
    ref,
    lastWeekStart,
    thisWeekEnd,
  );
  if (all.length <= 1) return double.nan;
  int thisWeekMinutes = 0;
  int lastWeekMinutes = 0;
  for (final session in all) {
    final minutes = session.actualDurationSeconds ~/ _secondsPerMinute;
    if (session.startTime.isBefore(thisWeekStart)) {
      lastWeekMinutes += minutes;
    } else {
      thisWeekMinutes += minutes;
    }
  }
  if (lastWeekMinutes == 0) return double.nan;
  return ((thisWeekMinutes - lastWeekMinutes) / lastWeekMinutes) * 100;
});

/// Builds allocation percentages from task-tag buckets and linked sessions.
final allocationProvider = FutureProvider<AllocationData>((ref) async {
  final sessions = await _loadFocusCompletedSessions(ref);
  final tasks = await _loadTasks(ref);
  if (sessions.isEmpty) {
    return const AllocationData(
      deepWorkPercent: 0,
      operationsPercent: 0,
      planningPercent: 0,
      optimizedPercent: 0,
      categoryHours: <String, double>{
        'Deep Work': 0,
        'Operations': 0,
        'Planning': 0,
      },
    );
  }

  final taskTagByUuid = <String, String>{
    for (final task in tasks) task.uuid: task.tag.toLowerCase(),
  };
  final payload = <String, Object>{
    'sessions': _sessionRawRows(sessions),
    'taskTags': taskTagByUuid,
  };
  final result = sessions.length > _aggregationThreshold
      ? await compute(_computeAllocationRaw, payload)
      : _computeAllocationRaw(payload);

  return AllocationData(
    deepWorkPercent: result['deepWorkPercent']! as double,
    operationsPercent: result['operationsPercent']! as double,
    planningPercent: result['planningPercent']! as double,
    optimizedPercent: result['optimizedPercent']! as double,
    categoryHours: Map<String, double>.from(
      result['categoryHours']! as Map<dynamic, dynamic>,
    ),
  );
});

/// Returns 90-day activity cells for heatmap.
final consistencyArchiveProvider = FutureProvider<List<DayActivityData>>((
  ref,
) async {
  final now = DateTime.now();
  final startDay = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(const Duration(days: _archiveDays - 1));
  final endDay = DateTime(
    now.year,
    now.month,
    now.day,
  ).add(const Duration(days: 1));

  final sessions = await _loadCompletedSessionsInRange(ref, startDay, endDay);
  final tasks = await _loadTasks(ref);
  final payload = <String, Object>{
    'nowMs': now.millisecondsSinceEpoch,
    'sessions': _sessionRawRows(sessions),
    'taskUpdates': tasks
        .map(
          (task) => <String, Object>{
            'updatedMs': task.updatedAt.millisecondsSinceEpoch,
          },
        )
        .toList(),
  };
  final rows = sessions.length > _aggregationThreshold
      ? await compute(_computeConsistencyRows, payload)
      : _computeConsistencyRows(payload);
  return rows
      .map(
        (row) => DayActivityData(
          date: DateTime.fromMillisecondsSinceEpoch(row['dateMs']! as int),
          focusMinutes: row['focusMinutes']! as int,
          sessionCount: row['sessionCount']! as int,
          tasksWorked: row['tasksWorked']! as int,
        ),
      )
      .toList();
});

/// Calculates this-year average focus duration and change vs last year.
final avgSessionDurationProvider = FutureProvider<SessionDurationData>((
  ref,
) async {
  final now = DateTime.now();
  final thisYearStart = DateTime(now.year, 1, 1);
  final lastYearStart = DateTime(now.year - 1, 1, 1);
  final nextYearStart = DateTime(now.year + 1, 1, 1);

  final sessions = await _loadFocusCompletedSessionsInRange(
    ref,
    lastYearStart,
    nextYearStart,
  );
  final thisYearSessions = sessions
      .where((s) => !s.startTime.isBefore(thisYearStart))
      .toList();
  final lastYearSessions = sessions
      .where(
        (s) =>
            !s.startTime.isBefore(lastYearStart) &&
            s.startTime.isBefore(thisYearStart),
      )
      .toList();

  final thisYearAvg = thisYearSessions.isEmpty
      ? 0
      : thisYearSessions.fold<int>(
              0,
              (sum, s) => sum + s.actualDurationSeconds,
            ) ~/
            thisYearSessions.length;
  final lastYearAvg = lastYearSessions.isEmpty
      ? 0
      : lastYearSessions.fold<int>(
              0,
              (sum, s) => sum + s.actualDurationSeconds,
            ) ~/
            lastYearSessions.length;

  final monthlyPoints = List<MonthlyDurationPoint>.generate(12, (index) {
    final month = index + 1;
    final monthly = thisYearSessions
        .where((s) => s.startTime.month == month)
        .toList();
    final avg = monthly.isEmpty
        ? 0
        : monthly.fold<int>(0, (sum, s) => sum + s.actualDurationSeconds) ~/
              monthly.length;
    return MonthlyDurationPoint(
      monthLabel: DateFormat('MMM').format(DateTime(now.year, month)),
      seconds: avg,
    );
  });

  return SessionDurationData(
    avgSeconds: thisYearAvg,
    changeSeconds: thisYearAvg - lastYearAvg,
    hasLastYearData: lastYearSessions.isNotEmpty,
    monthlyAverageSeconds: monthlyPoints,
  );
});

/// Calculates overall completion ratio plus month-over-month change.
final taskCompletionProvider = FutureProvider<TaskCompletionData>((ref) async {
  final allTasks = await _loadTasks(ref);
  final completedTasks = allTasks.where((task) => task.status == 'done').length;
  final totalTasks = allTasks.length;
  final ratio = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

  final now = DateTime.now();
  final thisMonthStart = DateTime(now.year, now.month, 1);
  final lastMonthStart = DateTime(
    now.month == 1 ? now.year - 1 : now.year,
    now.month == 1 ? 12 : now.month - 1,
    1,
  );
  final thisMonthDone = allTasks
      .where(
        (task) =>
            task.status == 'done' && !task.updatedAt.isBefore(thisMonthStart),
      )
      .length;
  final lastMonthDone = allTasks
      .where(
        (task) =>
            task.status == 'done' &&
            !task.updatedAt.isBefore(lastMonthStart) &&
            task.updatedAt.isBefore(thisMonthStart),
      )
      .length;
  final double changePercent = lastMonthDone == 0
      ? 0.0
      : ((thisMonthDone - lastMonthDone) / lastMonthDone) * 100;

  final weeklyTrend = <WeeklyCompletionPoint>[];
  final currentWeekStart = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: now.weekday - 1));
  for (int i = 5; i >= 0; i--) {
    final weekStart = currentWeekStart.subtract(
      Duration(days: i * _daysInWeek),
    );
    final weekEnd = weekStart.add(const Duration(days: _daysInWeek));
    final updatedInWeek = allTasks
        .where(
          (task) =>
              !task.updatedAt.isBefore(weekStart) &&
              task.updatedAt.isBefore(weekEnd),
        )
        .toList();
    final doneInWeek = updatedInWeek
        .where((task) => task.status == 'done')
        .length;
    final weekRatio = updatedInWeek.isEmpty
        ? 0.0
        : doneInWeek / updatedInWeek.length;
    weeklyTrend.add(
      WeeklyCompletionPoint(
        weekLabel: DateFormat('MMM d').format(weekStart),
        ratio: weekRatio,
      ),
    );
  }

  return TaskCompletionData(
    ratio: ratio,
    thisMonthCompleted: thisMonthDone,
    lastMonthCompleted: lastMonthDone,
    changePercent: changePercent,
    totalTasks: totalTasks,
    completedTasks: completedTasks,
    weeklyTrend: weeklyTrend,
  );
});

final analyticsTargetDurationProvider = FutureProvider<int>((ref) async {
  // Normalizes target lookup across web/local stores so progress bars share one source.
  if (kIsWeb) {
    return PomodoroWebStore.instance.ensureSettings().focusDuration;
  }
  final isar = await ref.watch(isarProvider.future);
  final settings =
      await (isar as dynamic).focusGoalSettings.get(1) as FocusGoalSettings?;
  return settings?.focusDuration ?? 1500;
});

Future<List<PomodoroSession>> _loadFocusCompletedSessions(Ref ref) async {
  // Dedicated helper to keep all focus-only aggregations using identical filtering.
  final all = await _loadCompletedSessions(ref);
  return all.where((session) => session.sessionType == 'focus').toList();
}

Future<List<PomodoroSession>> _loadFocusCompletedSessionsInRange(
  Ref ref,
  DateTime start,
  DateTime end,
) async {
  // Shared range loader for weekly and yearly charts.
  final all = await _loadCompletedSessionsInRange(ref, start, end);
  return all.where((session) => session.sessionType == 'focus').toList();
}

Future<List<PomodoroSession>> _loadCompletedSessions(Ref ref) async {
  // Pulls completed sessions from the platform-specific persistence layer.
  if (kIsWeb) {
    return PomodoroWebStore.instance.sessions
        .where((s) => s.isCompleted)
        .toList();
  }
  final isar = await ref.watch(isarProvider.future);
  return await (isar as dynamic).pomodoroSessions
          .filter()
          .isCompletedEqualTo(true)
          .findAll()
      as List<PomodoroSession>;
}

Future<List<PomodoroSession>> _loadCompletedSessionsInRange(
  Ref ref,
  DateTime start,
  DateTime end,
) async {
  // Keeps date-window semantics consistent (start inclusive, end exclusive).
  if (kIsWeb) {
    return PomodoroWebStore.instance.sessions
        .where(
          (s) =>
              s.isCompleted &&
              !s.startTime.isBefore(start) &&
              s.startTime.isBefore(end),
        )
        .toList();
  }
  final isar = await ref.watch(isarProvider.future);
  return await (isar as dynamic).pomodoroSessions
          .filter()
          .isCompletedEqualTo(true)
          .startTimeBetween(start, end)
          .findAll()
      as List<PomodoroSession>;
}

Future<List<Task>> _loadTasks(Ref ref) async {
  // Resolves task list through Riverpod on web and Isar on local platforms.
  if (kIsWeb) {
    return ref.watch(taskNotifierProvider.future);
  }
  final isar = await ref.watch(isarProvider.future);
  return await (isar as dynamic).collection<Task>().where().findAll()
      as List<Task>;
}

List<Map<String, Object?>> _sessionRawRows(List<PomodoroSession> sessions) {
  // Plain map payloads are isolate-safe for compute().
  return sessions
      .map(
        (session) => <String, Object?>{
          'startMs': session.startTime.millisecondsSinceEpoch,
          'durationSec': session.actualDurationSeconds,
          'sessionType': session.sessionType,
          'linkedTaskId': session.linkedTaskId ?? '',
        },
      )
      .toList();
}

double _computeFocusRecordHours(List<Map<String, Object?>> rows) {
  // Aggregates per-day focus totals and returns the best day in hours.
  final totals = <String, int>{};
  for (final row in rows) {
    if (row['sessionType'] != 'focus') continue;
    final date = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.fromMillisecondsSinceEpoch(row['startMs']! as int));
    totals[date] = (totals[date] ?? 0) + (row['durationSec']! as int);
  }
  if (totals.isEmpty) return 0;
  final maxSeconds = totals.values.reduce(max);
  return maxSeconds / _secondsPerHour;
}

List<Map<String, Object?>> _computeWeeklyVelocityRows(
  Map<String, Object> payload,
) {
  // Isolate wrapper for weekly velocity since DayVelocity itself is not transferable.
  final rows = payload['sessions']! as List<Map<String, Object?>>;
  final now = DateTime.fromMillisecondsSinceEpoch(payload['nowMs']! as int);
  final weekStart = DateTime.fromMillisecondsSinceEpoch(
    payload['weekStartMs']! as int,
  );
  return _computeWeeklyVelocity(rows: rows, now: now, weekStart: weekStart)
      .map(
        (item) => <String, Object?>{
          'weekday': item.weekday,
          'sessionCount': item.sessionCount,
          'totalMinutes': item.totalMinutes,
          'isToday': item.isToday,
        },
      )
      .toList();
}

List<DayVelocity> _computeWeeklyVelocity({
  required List<Map<String, Object?>> rows,
  required DateTime now,
  required DateTime weekStart,
}) {
  // Builds a fixed seven-day structure so charts always render Mon..Sun.
  final map = <int, List<int>>{
    for (int i = 0; i < _daysInWeek; i++) i: <int>[0, 0], // [sessions, minutes]
  };
  for (final row in rows) {
    if (row['sessionType'] != 'focus') continue;
    final start = DateTime.fromMillisecondsSinceEpoch(row['startMs']! as int);
    final dayIndex = start.difference(weekStart).inDays;
    if (dayIndex < 0 || dayIndex >= _daysInWeek) continue;
    map[dayIndex]![0] = map[dayIndex]![0] + 1;
    map[dayIndex]![1] =
        map[dayIndex]![1] + ((row['durationSec']! as int) ~/ 60);
  }
  return List<DayVelocity>.generate(_daysInWeek, (index) {
    final day = weekStart.add(Duration(days: index));
    final today =
        now.year == day.year && now.month == day.month && now.day == day.day;
    return DayVelocity(
      weekday: index,
      sessionCount: map[index]![0],
      totalMinutes: map[index]![1],
      isToday: today,
    );
  });
}

Map<String, Object> _computeAllocationRaw(Map<String, Object> payload) {
  // Classifies session duration into product buckets by linked task tag.
  final rows = payload['sessions']! as List<Map<String, Object?>>;
  final taskTags = payload['taskTags']! as Map<String, String>;
  int deepWork = 0;
  int operations = 0;
  int planning = 0;
  int other = 0;
  int meaningful = 0;
  int total = 0;

  for (final row in rows) {
    final duration = row['durationSec']! as int;
    final taskId = row['linkedTaskId']! as String;
    total += duration;
    final tag = taskTags[taskId]?.toLowerCase() ?? '';
    if (_deepWorkTags.contains(tag)) {
      deepWork += duration;
      meaningful += duration;
    } else if (_operationsTags.contains(tag)) {
      operations += duration;
      meaningful += duration;
    } else if (_planningTags.contains(tag)) {
      planning += duration;
    } else {
      other += duration;
    }
  }

  final safeTotal = total == 0 ? 1 : total;
  return <String, Object>{
    'deepWorkPercent': deepWork * 100 / safeTotal,
    'operationsPercent': operations * 100 / safeTotal,
    'planningPercent': planning * 100 / safeTotal,
    'optimizedPercent': meaningful * 100 / safeTotal,
    'categoryHours': <String, double>{
      'Deep Work': deepWork / _secondsPerHour,
      'Operations': operations / _secondsPerHour,
      'Planning': planning / _secondsPerHour,
      'Unassigned': other / _secondsPerHour,
    },
  };
}

List<Map<String, Object?>> _computeConsistencyRows(
  Map<String, Object> payload,
) {
  // Produces contiguous 90-day cells with both focus and task-touch metrics.
  final now = DateTime.fromMillisecondsSinceEpoch(payload['nowMs']! as int);
  final sessions = payload['sessions']! as List<Map<String, Object?>>;
  final taskUpdates = payload['taskUpdates']! as List<Map<String, Object>>;

  final byDate = <String, List<int>>{}; // [minutes, sessions]
  for (final row in sessions) {
    final date = DateTime.fromMillisecondsSinceEpoch(row['startMs']! as int);
    final key = DateFormat('yyyy-MM-dd').format(date);
    byDate.putIfAbsent(key, () => <int>[0, 0]);
    byDate[key]![0] = byDate[key]![0] + ((row['durationSec']! as int) ~/ 60);
    byDate[key]![1] = byDate[key]![1] + 1;
  }

  final taskCounts = <String, int>{};
  for (final row in taskUpdates) {
    final date = DateTime.fromMillisecondsSinceEpoch(row['updatedMs']! as int);
    final key = DateFormat('yyyy-MM-dd').format(date);
    taskCounts[key] = (taskCounts[key] ?? 0) + 1;
  }

  final output = <Map<String, Object?>>[];
  for (int i = _archiveDays - 1; i >= 0; i--) {
    final day = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: i));
    final key = DateFormat('yyyy-MM-dd').format(day);
    final minutesAndSessions = byDate[key] ?? const <int>[0, 0];
    output.add(<String, Object?>{
      'dateMs': day.millisecondsSinceEpoch,
      'focusMinutes': minutesAndSessions[0],
      'sessionCount': minutesAndSessions[1],
      'tasksWorked': taskCounts[key] ?? 0,
    });
  }
  return output;
}
