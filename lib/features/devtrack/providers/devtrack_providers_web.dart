import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/coding_session.dart';
import '../models/day_activity_data.dart';
import '../models/dev_project.dart';
import '../models/skill_entry.dart';
import '../../pomodoro/providers/pomodoro_web_store.dart';
import 'project_notifier.dart';
import 'skill_notifier.dart';

// ── Helper loaders ──────────────────────────────────────────────────────────
Future<List<DevProject>> _loadProjectsFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonStr = prefs.getString('devtrack_projects');
  if (jsonStr == null) return [];
  try {
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return DevProject()
        ..id = map['id'] ?? 0
        ..uuid = map['uuid'] ?? ''
        ..name = map['name'] ?? ''
        ..description = map['description'] ?? ''
        ..status = map['status'] ?? 'active'
        ..primaryLanguage = map['primaryLanguage'] ?? ''
        ..techStack = List<String>.from(map['techStack'] ?? [])
        ..completionPercent = map['completionPercent'] ?? 0
        ..startedAt = DateTime.parse(map['startedAt'] ?? DateTime.now().toIso8601String())
        ..completedAt = map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null
        ..lastActiveAt = DateTime.parse(map['lastActiveAt'] ?? DateTime.now().toIso8601String())
        ..linkedTaskIds = List<String>.from(map['linkedTaskIds'] ?? [])
        ..totalCodingMinutes = map['totalCodingMinutes'] ?? 0
        ..colorHex = map['colorHex'] ?? '#006EE6'
        ..iconName = map['iconName'] ?? 'code';
    }).toList();
  } catch (e) {
    return [];
  }
}

Future<List<CodingSession>> _loadCodingSessionsFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonStr = prefs.getString('devtrack_sessions');
  if (jsonStr == null) return [];
  try {
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return CodingSession()
        ..id = map['id'] ?? 0
        ..uuid = map['uuid'] ?? ''
        ..projectId = map['projectId'] ?? ''
        ..language = map['language'] ?? ''
        ..startTime = DateTime.parse(map['startTime'] ?? DateTime.now().toIso8601String())
        ..endTime = DateTime.parse(map['endTime'] ?? DateTime.now().toIso8601String())
        ..durationMinutes = map['durationMinutes'] ?? 0
        ..sessionType = map['sessionType'] ?? 'focus'
        ..notes = map['notes'] ?? ''
        ..linkedToPomodoro = map['linkedToPomodoro'] ?? false
        ..linkedPomodoroId = map['linkedPomodoroId'];
    }).toList();
  } catch (e) {
    return [];
  }
}

Future<List<SkillEntry>> _loadSkillsFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonStr = prefs.getString('devtrack_skills');
  if (jsonStr == null) return [];
  try {
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return SkillEntry()
        ..id = map['id'] ?? 0
        ..uuid = map['uuid'] ?? ''
        ..skillName = map['skillName'] ?? ''
        ..category = map['category'] ?? ''
        ..proficiencyLevel = map['proficiencyLevel'] ?? 1
        ..hoursInvested = map['hoursInvested'] ?? 0
        ..firstLearnedAt = DateTime.parse(map['firstLearnedAt'] ?? DateTime.now().toIso8601String())
        ..lastPracticedAt = DateTime.parse(map['lastPracticedAt'] ?? DateTime.now().toIso8601String())
        ..linkedProjectIds = List<String>.from(map['linkedProjectIds'] ?? [])
        ..notes = map['notes'] ?? '';
    }).toList();
  } catch (e) {
    return [];
  }
}

// ── Providers ───────────────────────────────────────────────────────────────
final allProjectsProvider = FutureProvider<List<DevProject>>((ref) async {
  final list = ref.watch(projectNotifierProvider).valueOrNull;
  if (list != null) return list;
  return _loadProjectsFromPrefs();
});

final activeProjectsProvider = FutureProvider<List<DevProject>>((ref) async {
  final projects = await ref.watch(allProjectsProvider.future);
  return projects.where((p) => p.status == 'active').toList();
});

final allCodingSessionsProvider = FutureProvider<List<CodingSession>>((ref) async {
  ref.watch(projectNotifierProvider);
  final sessions = await _loadCodingSessionsFromPrefs();
  sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
  return sessions;
});

final todayCodingSessionsProvider = FutureProvider<List<CodingSession>>((ref) async {
  final sessions = await ref.watch(allCodingSessionsProvider.future);
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd = todayStart.add(const Duration(days: 1));
  return sessions.where((s) => s.startTime.isAfter(todayStart) && s.startTime.isBefore(todayEnd)).toList();
});

final devtrackLanguageDistributionProvider = FutureProvider<Map<String, double>>((ref) async {
  final sessions = await ref.watch(allCodingSessionsProvider.future);
  final Map<String, int> totals = {};
  for (final s in sessions) {
    totals[s.language] = (totals[s.language] ?? 0) + s.durationMinutes;
  }
  final total = totals.values.fold(0, (a, b) => a + b);
  if (total == 0) return {};
  return totals.map((k, v) => MapEntry(k, v / total * 100));
});

final activityHeatmapProvider = FutureProvider<List<DayActivityData>>((ref) async {
  final sessions = await ref.watch(allCodingSessionsProvider.future);
  final pomodoros = PomodoroWebStore.instance.sessions.where((s) => s.isCompleted).toList();

  final now = DateTime.now();
  final List<DayActivityData> result = [];
  for (int i = 89; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    
    final daySessions = sessions.where((s) => s.startTime.isAfter(start) && s.startTime.isBefore(end)).toList();
    final dayPomodoros = pomodoros.where((s) => s.startTime.isAfter(start) && s.startTime.isBefore(end)).toList();
    
    result.add(DayActivityData(
      date: day,
      codingMinutes: daySessions.fold(0, (s, e) => s + e.durationMinutes),
      pomodoroCount: dayPomodoros.length,
      sessionCount: daySessions.length,
    ));
  }
  return result;
});

final allSkillsProvider = FutureProvider<List<SkillEntry>>((ref) async {
  final list = ref.watch(skillNotifierProvider).valueOrNull;
  if (list != null) return list;
  final skills = await _loadSkillsFromPrefs();
  skills.sort((a, b) => b.hoursInvested.compareTo(a.hoursInvested));
  return skills;
});

final codingStreakProvider = FutureProvider<int>((ref) async {
  final sessions = await ref.watch(allCodingSessionsProvider.future);
  if (sessions.isEmpty) return 0;
  
  int streak = 0;
  DateTime day = DateTime.now();
  while (true) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final daySessions = sessions.where((s) => s.startTime.isAfter(start) && s.startTime.isBefore(end)).toList();
    if (daySessions.isEmpty) break;
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
});

final totalCodingHoursProvider = FutureProvider<double>((ref) async {
  final sessions = await ref.watch(allCodingSessionsProvider.future);
  final total = sessions.fold(0, (sum, s) => sum + s.durationMinutes);
  return total / 60;
});
