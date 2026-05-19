import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/task.dart';
import '../providers/task_providers.dart';
import '../../../app/theme.dart';

class DependencyManager extends ConsumerStatefulWidget {
  const DependencyManager({super.key, required this.task});

  final Task task;

  @override
  ConsumerState<DependencyManager> createState() => _DependencyManagerState();
}

class _DependencyManagerState extends ConsumerState<DependencyManager> {
  String _query = '';
  String? _error;

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskNotifierProvider).valueOrNull ?? <Task>[];
    final currentTask = allTasks
        .where((task) => task.uuid == widget.task.uuid)
        .firstOrNull;
    if (currentTask == null) return const SizedBox.shrink();

    final candidates = allTasks
        .where(
          (task) =>
              task.uuid != currentTask.uuid &&
              !currentTask.dependencyIds.contains(task.uuid) &&
              task.title.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Dependency Manager',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search task to add dependency',
                ),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppTheme.danger),
                ),
              ),
            SizedBox(
              height: 260,
              child: ListView(
                children: [
                  for (final depId in currentTask.dependencyIds)
                    ListTile(
                      title: Text(
                        allTasks
                                .where((task) => task.uuid == depId)
                                .firstOrNull
                                ?.title ??
                            depId,
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          final next = [...currentTask.dependencyIds]
                            ..remove(depId);
                          await ref
                              .read(taskNotifierProvider.notifier)
                              .updateDependencies(currentTask.uuid, next);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  for (final candidate in candidates)
                    ListTile(
                      title: Text(candidate.title),
                      trailing: IconButton(
                        onPressed: () async {
                          final notifier = ref.read(
                            taskNotifierProvider.notifier,
                          );
                          final circular = notifier.hasCircularDependency(
                            currentTask.uuid,
                            candidate.uuid,
                          );
                          if (circular) {
                            setState(
                              () => _error = 'Circular dependency detected',
                            );
                            return;
                          }
                          setState(() => _error = null);
                          final next = [
                            ...currentTask.dependencyIds,
                            candidate.uuid,
                          ];
                          await notifier.updateDependencies(
                            currentTask.uuid,
                            next,
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
