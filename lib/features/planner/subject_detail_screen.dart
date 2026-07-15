import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../core/models/pomodoro_session.dart';
import '../../core/providers/isar_provider.dart';
import '../../core/widgets/error_card.dart';
import 'providers/planner_providers.dart';
import 'widgets/add_subject_sheet.dart';
import '../pomodoro/providers/pomodoro_web_store.dart';
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
        error: (_, __) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ErrorCard(
              message: 'Failed to load subject',
              onRetry: () => ref.invalidate(allSubjectsProvider),
            ),
          ),
        ),
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
                      onChanged: (val) {
                        if (val != null) {
                          ref
                              .read(subjectNotifierProvider.notifier)
                              .toggleModuleCompletion(
                                subject.uuid,
                                module.uuid,
                                val,
                              );
                        }
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
                error: (_, __) => ErrorCard(
                  message: 'Failed to load session data',
                  onRetry: () =>
                      ref.invalidate(_subjectSessionsProvider(subjectId)),
                ),
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
                onPressed: () async {
                  final textController = TextEditingController();
                  final name = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppTheme.surfaceCard,
                      title: const Text('Add New Module'),
                      content: TextField(
                        controller: textController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Module name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(
                            context,
                            textController.text.trim(),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                          ),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  );
                  if (name != null && name.isNotEmpty) {
                    await ref
                        .read(subjectNotifierProvider.notifier)
                        .addModule(subject.uuid, name);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Add new module'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: AppTheme.surfaceCard,
                    builder: (_) => AddSubjectSheet(
                      initialSubject: subject,
                      onSubmit: (updatedSubject, examMilestone) async {
                        await ref
                            .read(subjectNotifierProvider.notifier)
                            .updateSubject(updatedSubject);
                        if (examMilestone != null) {
                          await ref
                              .read(milestoneNotifierProvider.notifier)
                              .addMilestone(examMilestone);
                        }
                      },
                    ),
                  );
                },
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
      List<PomodoroSession> all;
      if (kIsWeb) {
        all = PomodoroWebStore.instance.sessions;
      } else {
        final isar = await ref.read(isarProvider.future);
        all = await isar.collection<PomodoroSession>().where().findAll();
      }
      // Handle sessions linked directly or linked through focus blocks that target this subject
      final blocks = await ref.watch(focusBlockNotifierProvider.future);
      final linkedBlockIds = blocks
          .where((block) => block.linkedSubjectId == subjectId)
          .map((block) => block.uuid)
          .toSet();

      return all
          .where(
            (session) =>
                session.linkedTaskId == subjectId ||
                linkedBlockIds.contains(session.linkedTaskId),
          )
          .toList()
        ..sort((a, b) => b.startTime.compareTo(a.startTime));
    });

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
