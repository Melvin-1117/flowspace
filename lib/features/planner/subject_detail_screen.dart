import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/models/pomodoro_session.dart';
import '../../core/providers/isar_provider.dart';
import 'providers/planner_providers.dart';
import '../../app/theme.dart';

class SubjectDetailScreen extends ConsumerWidget {
  const SubjectDetailScreen({required this.subjectId, super.key});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(allSubjectsProvider);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text('Subject Details'),
      ),
      body: subjects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load subject')),
        data: (items) {
          final subject = items.where((s) => s.uuid == subjectId).firstOrNull;
          if (subject == null) {
            return const Center(child: Text('Subject not found'));
          }
          final sessionsAsync = ref.watch(_subjectSessionsProvider(subjectId));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                subject.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Modules',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...subject.modules.map(
                (module) => ExpansionTile(
                  title: Text(module.name),
                  subtitle: Text('Module ${module.moduleNumber}'),
                  children: [
                    CheckboxListTile(
                      value: module.isCompleted,
                      onChanged: (_) {
                        ref
                            .read(subjectNotifierProvider.notifier)
                            .incrementModule(subject.uuid);
                      },
                      title: const Text('Completed'),
                    ),
                    const ListTile(
                      title: Text('Linked notes'),
                      subtitle: Text(
                        'Open notes integration from subject detail',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              sessionsAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('Failed to load session data'),
                data: (sessions) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pomodoro Sessions',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ...sessions.map(
                      (session) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(session.linkedTaskTitle ?? ''),
                        subtitle: Text(
                          '${(session.actualDurationSeconds / 60).round()} mins • ${session.startTime}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add new module'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                child: const Text('Edit subject'),
              ),
            ],
          );
        },
      ),
    );
  }
}

final _subjectSessionsProvider =
    FutureProvider.family<List<PomodoroSession>, String>((
      ref,
      subjectId,
    ) async {
      final isar = await ref.read(isarProvider.future);
      final all =
          await isar.pomodoroSessions.where().findAll()
              as List<PomodoroSession>;
      return all.where((session) => session.linkedTaskId == subjectId).toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));
    });

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
