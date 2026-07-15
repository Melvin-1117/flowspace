import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/coding_session.dart';
import '../models/dev_project.dart';
import 'devtrack_providers.dart';

class ProjectNotifier extends AsyncNotifier<List<DevProject>> {
  @override
  Future<List<DevProject>> build() async {
    return _loadProjects();
  }

  Future<List<DevProject>> _loadProjects() async {
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
          ..startedAt = DateTime.parse(
            map['startedAt'] ?? DateTime.now().toIso8601String(),
          )
          ..completedAt = map['completedAt'] != null
              ? DateTime.parse(map['completedAt'])
              : null
          ..lastActiveAt = DateTime.parse(
            map['lastActiveAt'] ?? DateTime.now().toIso8601String(),
          )
          ..linkedTaskIds = List<String>.from(map['linkedTaskIds'] ?? [])
          ..totalCodingMinutes = map['totalCodingMinutes'] ?? 0
          ..colorHex = map['colorHex'] ?? '#006EE6'
          ..iconName = map['iconName'] ?? 'code';
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveProjects(List<DevProject> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final list = projects
        .map(
          (p) => {
            'id': p.id,
            'uuid': p.uuid,
            'name': p.name,
            'description': p.description,
            'status': p.status,
            'primaryLanguage': p.primaryLanguage,
            'techStack': p.techStack,
            'completionPercent': p.completionPercent,
            'startedAt': p.startedAt.toIso8601String(),
            'completedAt': p.completedAt?.toIso8601String(),
            'lastActiveAt': p.lastActiveAt.toIso8601String(),
            'linkedTaskIds': p.linkedTaskIds,
            'totalCodingMinutes': p.totalCodingMinutes,
            'colorHex': p.colorHex,
            'iconName': p.iconName,
          },
        )
        .toList();
    await prefs.setString('devtrack_projects', jsonEncode(list));
  }

  Future<void> addProject(DevProject p) async {
    p.uuid = const Uuid().v4();
    p.startedAt = DateTime.now();
    p.lastActiveAt = DateTime.now();
    final current = await _loadProjects();
    current.insert(0, p);
    await _saveProjects(current);
    state = AsyncData(current);
    ref.invalidate(allProjectsProvider);
    ref.invalidate(activeProjectsProvider);
  }

  Future<void> updateProject(DevProject p) async {
    final current = await _loadProjects();
    final index = current.indexWhere((item) => item.uuid == p.uuid);
    if (index >= 0) {
      current[index] = p;
      await _saveProjects(current);
      state = AsyncData(current);
      ref.invalidate(allProjectsProvider);
      ref.invalidate(activeProjectsProvider);
    }
  }

  Future<void> deleteProject(String uuid) async {
    final current = await _loadProjects();
    current.removeWhere((item) => item.uuid == uuid);
    await _saveProjects(current);
    state = AsyncData(current);
    ref.invalidate(allProjectsProvider);
    ref.invalidate(activeProjectsProvider);
  }

  Future<void> updateProgress(String uuid, int percent) async {
    final current = await _loadProjects();
    final index = current.indexWhere((item) => item.uuid == uuid);
    if (index >= 0) {
      final project = current[index];
      project.completionPercent = percent.clamp(0, 100);
      project.lastActiveAt = DateTime.now();
      if (percent >= 100) {
        project.status = 'completed';
        project.completedAt = DateTime.now();
      }
      await _saveProjects(current);
      state = AsyncData(current);
      ref.invalidate(allProjectsProvider);
      ref.invalidate(activeProjectsProvider);
    }
  }

  Future<void> logCodingSession(CodingSession s) async {
    s.uuid = const Uuid().v4();
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('devtrack_sessions');
    List<CodingSession> sessions = [];
    if (jsonStr != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonStr);
        sessions = list.map((item) {
          final map = item as Map<String, dynamic>;
          return CodingSession()
            ..id = map['id'] ?? 0
            ..uuid = map['uuid'] ?? ''
            ..projectId = map['projectId'] ?? ''
            ..language = map['language'] ?? ''
            ..startTime = DateTime.parse(
              map['startTime'] ?? DateTime.now().toIso8601String(),
            )
            ..endTime = DateTime.parse(
              map['endTime'] ?? DateTime.now().toIso8601String(),
            )
            ..durationMinutes = map['durationMinutes'] ?? 0
            ..sessionType = map['sessionType'] ?? 'focus'
            ..notes = map['notes'] ?? ''
            ..linkedToPomodoro = map['linkedToPomodoro'] ?? false
            ..linkedPomodoroId = map['linkedPomodoroId'];
        }).toList();
      } catch (e) {
        // ignore
      }
    }
    sessions.insert(0, s);
    final list = sessions
        .map(
          (cs) => {
            'id': cs.id,
            'uuid': cs.uuid,
            'projectId': cs.projectId,
            'language': cs.language,
            'startTime': cs.startTime.toIso8601String(),
            'endTime': cs.endTime.toIso8601String(),
            'durationMinutes': cs.durationMinutes,
            'sessionType': cs.sessionType,
            'notes': cs.notes,
            'linkedToPomodoro': cs.linkedToPomodoro,
            'linkedPomodoroId': cs.linkedPomodoroId,
          },
        )
        .toList();
    await prefs.setString('devtrack_sessions', jsonEncode(list));

    if (s.projectId.isNotEmpty) {
      final current = await _loadProjects();
      final index = current.indexWhere((p) => p.uuid == s.projectId);
      if (index >= 0) {
        current[index].totalCodingMinutes += s.durationMinutes;
        current[index].lastActiveAt = DateTime.now();
        await _saveProjects(current);
        state = AsyncData(current);
      }
    }

    ref.invalidate(allCodingSessionsProvider);
    ref.invalidate(todayCodingSessionsProvider);
    ref.invalidate(activityHeatmapProvider);
    ref.invalidate(devtrackLanguageDistributionProvider);
    ref.invalidate(codingStreakProvider);
    ref.invalidate(totalCodingHoursProvider);
    ref.invalidate(allProjectsProvider);
    ref.invalidate(activeProjectsProvider);
  }
}

final projectNotifierProvider =
    AsyncNotifierProvider<ProjectNotifier, List<DevProject>>(
      ProjectNotifier.new,
    );
