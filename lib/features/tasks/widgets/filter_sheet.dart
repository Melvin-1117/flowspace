import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_providers.dart';

class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskNotifierProvider).valueOrNull ?? [];
    final tags = tasks.map((task) => task.tag).toSet().toList()..sort();
    final current = ref.watch(activeFiltersProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            _sectionTitle('Priority'),
            Wrap(
              spacing: 8,
              children: ['high', 'med', 'low']
                  .map(
                    (value) => FilterChip(
                      label: Text(value.toUpperCase()),
                      selected: current.priorities.contains(value),
                      onSelected: (selected) {
                        final next = {...current.priorities};
                        if (selected) {
                          next.add(value);
                        } else {
                          next.remove(value);
                        }
                        ref.read(activeFiltersProvider.notifier).state = current
                            .copyWith(priorities: next);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            _sectionTitle('Tag'),
            Wrap(
              spacing: 8,
              children: tags
                  .map(
                    (tag) => FilterChip(
                      label: Text(tag),
                      selected: current.tags.contains(tag),
                      onSelected: (selected) {
                        final next = {...current.tags};
                        if (selected) {
                          next.add(tag);
                        } else {
                          next.remove(tag);
                        }
                        ref.read(activeFiltersProvider.notifier).state = current
                            .copyWith(tags: next);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            _sectionTitle('Due Date'),
            Wrap(
              spacing: 8,
              children: [
                _dueChip(context, ref, current, 'All', DueDateFilter.all),
                _dueChip(context, ref, current, 'Today', DueDateFilter.today),
                _dueChip(
                  context,
                  ref,
                  current,
                  'This Week',
                  DueDateFilter.week,
                ),
                _dueChip(
                  context,
                  ref,
                  current,
                  'Overdue',
                  DueDateFilter.overdue,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _sectionTitle('Status'),
            Wrap(
              spacing: 8,
              children: ['todo', 'inprogress', 'done']
                  .map(
                    (status) => FilterChip(
                      label: Text(status.toUpperCase()),
                      selected: current.statuses.contains(status),
                      onSelected: (selected) {
                        final next = {...current.statuses};
                        if (selected) {
                          next.add(status);
                        } else {
                          next.remove(status);
                        }
                        ref.read(activeFiltersProvider.notifier).state = current
                            .copyWith(statuses: next);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(activeFiltersProvider.notifier).state =
                          const TaskFilters();
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _dueChip(
    BuildContext context,
    WidgetRef ref,
    TaskFilters current,
    String title,
    DueDateFilter value,
  ) {
    return ChoiceChip(
      label: Text(title),
      selected: current.dueDate == value,
      onSelected: (_) {
        ref.read(activeFiltersProvider.notifier).state = current.copyWith(
          dueDate: value,
        );
      },
    );
  }
}
