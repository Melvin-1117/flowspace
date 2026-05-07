import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/focus_block.dart';
import '../../../core/models/milestone.dart';
import '../../../core/models/subject.dart';
import '../../../core/models/subject_module.dart';
import '../../../core/models/task.dart';

const String plannerSubjectTag = 'planner_subject';
const String plannerMilestoneTag = 'planner_milestone';
const String plannerFocusBlockTag = 'planner_focus_block';

class PlannerStorage {
  PlannerStorage._();

  static bool isPlannerRecord(Task task) {
    return task.tag == plannerSubjectTag ||
        task.tag == plannerMilestoneTag ||
        task.tag == plannerFocusBlockTag;
  }

  static Subject toSubject(Task task) {
    final payload = _jsonMap(task.description);
    final moduleMaps = (payload['modules'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>();

    final modules = moduleMaps.map((m) {
      return SubjectModule(
        uuid: (m['uuid'] as String?) ?? const Uuid().v4(),
        subjectId: task.uuid,
        name: (m['name'] as String?) ?? 'Module',
        moduleNumber: (m['moduleNumber'] as int?) ?? 1,
        isCompleted: (m['isCompleted'] as bool?) ?? false,
        completedAt: (m['completedAt'] as String?) == null
            ? null
            : DateTime.tryParse(m['completedAt'] as String),
        linkedNoteIds: (m['linkedNoteIds'] as List<dynamic>? ?? <dynamic>[])
            .map((e) => e.toString())
            .toList(),
      );
    }).toList();

    final completedModules = modules.where((m) => m.isCompleted).length;
    final totalModules = (payload['totalModules'] as int?) ?? modules.length;

    return Subject(
      id: task.id,
      uuid: task.uuid,
      name: task.title,
      iconName: (payload['iconName'] as String?) ?? 'menu_book',
      colorHex: (payload['colorHex'] as String?) ?? '#7C3AED',
      totalModules: totalModules <= 0 ? 1 : totalModules,
      completedModules: completedModules,
      examDate: task.dueDate,
      weeklyGoalHours: (payload['weeklyGoalHours'] as int?) ?? 6,
      createdAt: task.createdAt,
      modules: modules,
    );
  }

  static Task fromSubject(Subject subject, {Task? existing}) {
    final task =
        existing ??
        (Task()
          ..uuid = subject.uuid
          ..priority = 'med'
          ..status = 'inprogress'
          ..isRecurring = false
          ..recurringFrequency = 'weekly'
          ..assignToPomodoro = true
          ..subtasks = <String>[]
          ..subtaskCompleted = <bool>[]
          ..dependencyIds = <String>[]
          ..projectId = 'planner'
          ..pomodoroTarget = 1
          ..pomodoroCount = 0
          ..createdAt = subject.createdAt
          ..updatedAt = DateTime.now());

    final modules = subject.modules.isEmpty
        ? List<SubjectModule>.generate(
            subject.totalModules,
            (index) => SubjectModule(
              uuid: const Uuid().v4(),
              subjectId: subject.uuid,
              name: 'Module ${index + 1}',
              moduleNumber: index + 1,
              isCompleted: index < subject.completedModules,
              completedAt: index < subject.completedModules
                  ? DateTime.now()
                  : null,
              linkedNoteIds: const <String>[],
            ),
          )
        : subject.modules;

    task
      ..title = subject.name
      ..description = jsonEncode(<String, Object?>{
        'iconName': subject.iconName,
        'colorHex': subject.colorHex,
        'weeklyGoalHours': subject.weeklyGoalHours,
        'totalModules': subject.totalModules,
        'modules': modules
            .map(
              (m) => <String, Object?>{
                'uuid': m.uuid,
                'name': m.name,
                'moduleNumber': m.moduleNumber,
                'isCompleted': m.isCompleted,
                'completedAt': m.completedAt?.toIso8601String(),
                'linkedNoteIds': m.linkedNoteIds,
              },
            )
            .toList(),
      })
      ..tag = plannerSubjectTag
      ..status = subject.completedModules >= subject.totalModules
          ? 'done'
          : 'inprogress'
      ..dueDate = subject.examDate
      ..updatedAt = DateTime.now();

    return task;
  }

  static Milestone toMilestone(Task task) {
    final payload = _jsonMap(task.description);
    final checklistItems =
        (payload['checklistItems'] as List<dynamic>? ?? <dynamic>[])
            .map((e) => e.toString())
            .toList();
    final checklistDone =
        (payload['checklistCompleted'] as List<dynamic>? ?? <dynamic>[])
            .map((e) => e == true)
            .toList();
    while (checklistDone.length < checklistItems.length) {
      checklistDone.add(false);
    }

    return Milestone(
      id: task.id,
      uuid: task.uuid,
      title: task.title,
      description: (payload['description'] as String?) ?? task.description,
      linkedSubjectId: (payload['linkedSubjectId'] as String?),
      dueDate: task.dueDate ?? DateTime.now(),
      priority: (payload['priority'] as String?) ?? _priorityFor(task.dueDate),
      isCompleted: task.status == 'done',
      completedAt: (payload['completedAt'] as String?) == null
          ? null
          : DateTime.tryParse(payload['completedAt'] as String),
      checklistItems: checklistItems,
      checklistCompleted: checklistDone,
    );
  }

  static Task fromMilestone(Milestone milestone, {Task? existing}) {
    final task =
        existing ??
        (Task()
          ..uuid = milestone.uuid
          ..priority = 'high'
          ..status = 'todo'
          ..isRecurring = false
          ..recurringFrequency = 'none'
          ..assignToPomodoro = false
          ..subtasks = <String>[]
          ..subtaskCompleted = <bool>[]
          ..dependencyIds = <String>[]
          ..projectId = 'planner'
          ..pomodoroTarget = 0
          ..pomodoroCount = 0
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now());

    task
      ..title = milestone.title
      ..description = jsonEncode(<String, Object?>{
        'description': milestone.description,
        'linkedSubjectId': milestone.linkedSubjectId,
        'priority': milestone.priority,
        'completedAt': milestone.completedAt?.toIso8601String(),
        'checklistItems': milestone.checklistItems,
        'checklistCompleted': milestone.checklistCompleted,
      })
      ..tag = plannerMilestoneTag
      ..status = milestone.isCompleted ? 'done' : 'todo'
      ..dueDate = milestone.dueDate
      ..updatedAt = DateTime.now();

    return task;
  }

  static FocusBlock toFocusBlock(Task task) {
    final payload = _jsonMap(task.description);
    return FocusBlock(
      id: task.id,
      uuid: task.uuid,
      title: task.title,
      linkedSubjectId: payload['linkedSubjectId'] as String?,
      linkedTaskId: payload['linkedTaskId'] as String?,
      sessionType: (payload['sessionType'] as String?) ?? 'deepwork',
      scheduledTime: task.dueDate ?? DateTime.now(),
      durationMinutes: (payload['durationMinutes'] as int?) ?? 45,
      isCompleted: task.status == 'done',
      completedAt: (payload['completedAt'] as String?) == null
          ? null
          : DateTime.tryParse(payload['completedAt'] as String),
      repeatRule: (payload['repeatRule'] as String?) ?? 'none',
      reminderEnabled: (payload['reminderEnabled'] as bool?) ?? false,
      reminderMinutesBefore: (payload['reminderMinutesBefore'] as int?) ?? 15,
    );
  }

  static Task fromFocusBlock(FocusBlock block, {Task? existing}) {
    final task =
        existing ??
        (Task()
          ..uuid = block.uuid
          ..priority = 'med'
          ..status = 'todo'
          ..isRecurring = block.repeatRule != 'none'
          ..recurringFrequency = block.repeatRule
          ..assignToPomodoro = true
          ..subtasks = <String>[]
          ..subtaskCompleted = <bool>[]
          ..dependencyIds = <String>[]
          ..projectId = 'planner'
          ..pomodoroTarget = 0
          ..pomodoroCount = 0
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now());

    task
      ..title = block.title
      ..description = jsonEncode(<String, Object?>{
        'linkedSubjectId': block.linkedSubjectId,
        'linkedTaskId': block.linkedTaskId,
        'sessionType': block.sessionType,
        'durationMinutes': block.durationMinutes,
        'completedAt': block.completedAt?.toIso8601String(),
        'repeatRule': block.repeatRule,
        'reminderEnabled': block.reminderEnabled,
        'reminderMinutesBefore': block.reminderMinutesBefore,
      })
      ..tag = plannerFocusBlockTag
      ..status = block.isCompleted ? 'done' : 'todo'
      ..dueDate = block.scheduledTime
      ..updatedAt = DateTime.now();

    return task;
  }

  static String _priorityFor(DateTime? dueDate) {
    if (dueDate == null) return 'upcoming';
    final days = dueDate.difference(DateTime.now()).inDays;
    if (days <= 3) return 'critical';
    if (days <= 7) return 'high';
    if (days <= 14) return 'medium';
    return 'upcoming';
  }

  static Map<String, dynamic> _jsonMap(String source) {
    if (source.trim().isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      if (kDebugMode) {
        debugPrint('PlannerStorage: failed to parse JSON payload');
      }
    }
    return <String, dynamic>{};
  }
}
