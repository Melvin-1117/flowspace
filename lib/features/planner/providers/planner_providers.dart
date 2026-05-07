import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/focus_block.dart';
import '../../../core/models/milestone.dart';
import '../../../core/models/pomodoro_session.dart';
import '../../../core/models/subject.dart';
import '../../../core/models/task.dart';
import '../../../core/providers/isar_provider.dart';
import '../../pomodoro/providers/pomodoro_web_store.dart';
import 'focus_block_notifier.dart';
import 'milestone_notifier.dart';
import 'planner_storage.dart';
import 'subject_notifier.dart';

class SemesterHealth {
  const SemesterHealth({
    required this.score,
    required this.avgCompletion,
    required this.readiness,
    required this.focusRate,
    required this.streakConsistency,
  });

  final double score;
  final double avgCompletion;
  final double readiness;
  final double focusRate;
  final double streakConsistency;
}

class SearchResultItem {
  const SearchResultItem({
    required this.category,
    required this.title,
    required this.id,
  });

  final String category;
  final String title;
  final String id;
}

final plannerSearchQueryProvider = StateProvider<String>((_) => '');

final subjectNotifierProvider =
    AsyncNotifierProvider<SubjectNotifier, List<Subject>>(SubjectNotifier.new);

final milestoneNotifierProvider =
    AsyncNotifierProvider<MilestoneNotifier, List<Milestone>>(
      MilestoneNotifier.new,
    );

final focusBlockNotifierProvider =
    AsyncNotifierProvider<FocusBlockNotifier, List<FocusBlock>>(
      FocusBlockNotifier.new,
    );

// Loads every planner subject from persisted Isar Task records.
final allSubjectsProvider = FutureProvider<List<Subject>>((ref) async {
  return ref.watch(subjectNotifierProvider.future);
});

// Loads every planner milestone from persisted Isar Task records.
final allMilestonesProvider = FutureProvider<List<Milestone>>((ref) async {
  return ref.watch(milestoneNotifierProvider.future);
});

// Loads focus blocks for current day and marks expired pending items as missed.
final todayFocusBlocksProvider = FutureProvider<List<FocusBlock>>((ref) async {
  final blocks = await ref.watch(focusBlockNotifierProvider.future);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return blocks.where((block) {
    return !block.scheduledTime.isBefore(start) &&
        block.scheduledTime.isBefore(end);
  }).toList()..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
});

// Sums linked Pomodoro session durations for one subject.
final subjectHoursProvider = FutureProvider.family<double, String>((
  ref,
  subjectId,
) async {
  final sessions = await _loadSessions(ref);
  final totalSeconds = sessions
      .where(
        (session) => session.linkedTaskId == subjectId && session.isCompleted,
      )
      .fold<int>(0, (sum, session) => sum + session.actualDurationSeconds);
  return totalSeconds / 3600;
});

// Returns nearest incomplete milestone in future.
final nextMilestoneProvider = FutureProvider<Milestone?>((ref) async {
  final milestones = await ref.watch(allMilestonesProvider.future);
  final now = DateTime.now();
  milestones.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  for (final milestone in milestones) {
    if (!milestone.isCompleted && milestone.dueDate.isAfter(now)) {
      return milestone;
    }
  }
  return null;
});

// Emits a live countdown to next milestone every minute.
final milestoneCountdownProvider = StreamProvider<Duration>((ref) async* {
  final milestone = await ref.watch(nextMilestoneProvider.future);
  if (milestone == null) return;

  while (true) {
    final remaining = milestone.dueDate.difference(DateTime.now());
    if (remaining.isNegative) {
      yield remaining;
      break;
    }
    yield remaining;
    await Future<void>.delayed(const Duration(minutes: 1));
  }
});

// Computes weighted semester health score from planner and focus progress signals.
final semesterHealthProvider = FutureProvider<SemesterHealth>((ref) async {
  final subjects = await ref.watch(allSubjectsProvider.future);
  final milestones = await ref.watch(allMilestonesProvider.future);
  final focusBlocks = await ref.watch(todayFocusBlocksProvider.future);
  final streak = await _streakConsistency(ref);

  final avgCompletion = subjects.isEmpty
      ? 0.0
      : subjects.fold<double>(0, (sum, s) => sum + s.completionPercent) /
            subjects.length;
  final readiness = milestones.isEmpty
      ? 1.0
      : milestones.where((m) => !m.isOverdue).length / milestones.length;
  final focusRate = focusBlocks.isEmpty
      ? 1.0
      : focusBlocks.where((b) => b.isCompleted).length / focusBlocks.length;

  final health =
      (avgCompletion * 0.4) +
      (readiness * 0.3) +
      (focusRate * 0.2) +
      (streak * 0.1);

  return SemesterHealth(
    score: (health * 100).clamp(0, 100),
    avgCompletion: avgCompletion,
    readiness: readiness,
    focusRate: focusRate,
    streakConsistency: streak,
  );
});

final semesterHealthTrendProvider = FutureProvider<List<double>>((ref) async {
  final sessions = await _loadSessions(ref);
  final now = DateTime.now();
  final values = <double>[];
  for (var i = 6; i >= 0; i--) {
    final day = now.subtract(Duration(days: i));
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final completedFocus = sessions
        .where((s) => s.sessionType == 'focus' && s.isCompleted)
        .where((s) => !s.startTime.isBefore(start) && s.startTime.isBefore(end))
        .length;
    values.add((completedFocus / 6).clamp(0, 1).toDouble() * 100);
  }
  return values;
});

final plannerSearchResultsProvider = FutureProvider<List<SearchResultItem>>((
  ref,
) async {
  final query = ref.watch(plannerSearchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return const <SearchResultItem>[];

  final subjects = await ref.watch(allSubjectsProvider.future);
  final milestones = await ref.watch(allMilestonesProvider.future);
  final blocks = await ref.watch(todayFocusBlocksProvider.future);

  final results = <SearchResultItem>[];
  for (final subject in subjects) {
    if (subject.name.toLowerCase().contains(query)) {
      results.add(
        SearchResultItem(
          category: 'Subjects',
          title: subject.name,
          id: subject.uuid,
        ),
      );
    }
    for (final module in subject.modules) {
      if (module.name.toLowerCase().contains(query)) {
        results.add(
          SearchResultItem(
            category: 'Modules',
            title: '${subject.name} • ${module.name}',
            id: subject.uuid,
          ),
        );
      }
    }
  }
  for (final block in blocks) {
    if (block.title.toLowerCase().contains(query)) {
      results.add(
        SearchResultItem(
          category: 'Focus Blocks',
          title: block.title,
          id: block.uuid,
        ),
      );
    }
  }
  for (final milestone in milestones) {
    if (milestone.title.toLowerCase().contains(query)) {
      results.add(
        SearchResultItem(
          category: 'Milestones',
          title: milestone.title,
          id: milestone.uuid,
        ),
      );
    }
  }
  return results;
});

Future<List<PomodoroSession>> _loadSessions(Ref ref) async {
  if (kIsWeb) {
    return PomodoroWebStore.instance.sessions;
  }
  final isar = await ref.read(isarProvider.future);
  return await (isar as dynamic).pomodoroSessions.where().findAll()
      as List<PomodoroSession>;
}

Future<double> _streakConsistency(Ref ref) async {
  final sessions = await _loadSessions(ref);
  final now = DateTime.now();
  var daysWithFocus = 0;
  for (var i = 0; i < 7; i++) {
    final day = now.subtract(Duration(days: i));
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final hasFocus = sessions.any(
      (s) =>
          s.sessionType == 'focus' &&
          s.isCompleted &&
          !s.startTime.isBefore(start) &&
          s.startTime.isBefore(end),
    );
    if (hasFocus) daysWithFocus++;
  }
  return (daysWithFocus / 7).clamp(0, 1).toDouble();
}

Subject makeDefaultSubject({
  required String name,
  required String iconName,
  required String colorHex,
  required int totalModules,
  DateTime? examDate,
  required int weeklyGoalHours,
}) {
  return Subject(
    uuid: const Uuid().v4(),
    name: name,
    iconName: iconName,
    colorHex: colorHex,
    totalModules: totalModules,
    completedModules: 0,
    examDate: examDate,
    weeklyGoalHours: weeklyGoalHours,
    createdAt: DateTime.now(),
    modules: List<SubjectModule>.generate(
      totalModules,
      (index) => SubjectModule(
        uuid: const Uuid().v4(),
        subjectId: '',
        name: 'Module ${index + 1}',
        moduleNumber: index + 1,
        isCompleted: false,
        completedAt: null,
        linkedNoteIds: const <String>[],
      ),
    ),
  );
}

String plannerPriorityFromRemainingDays(int daysRemaining) {
  if (daysRemaining <= 3) return 'critical';
  if (daysRemaining <= 7) return 'high';
  if (daysRemaining <= 14) return 'medium';
  return 'upcoming';
}

int reminderNotificationId(String uuid, int offset) {
  return Object.hash(uuid, offset) & 0x7fffffff;
}

bool isPlannerTask(Task task) => PlannerStorage.isPlannerRecord(task);
