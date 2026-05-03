import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/task.dart';
import '../providers/task_providers.dart';

class TaskListView extends ConsumerWidget {
  const TaskListView({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = {
      'todo': tasks.where((task) => task.status == 'todo').toList(),
      'inprogress': tasks.where((task) => task.status == 'inprogress').toList(),
      'done': tasks.where((task) => task.status == 'done').toList(),
    };
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 150),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              _title(entry.key),
              style: const TextStyle(
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
          ),
          for (final task in entry.value)
            Dismissible(
              key: ValueKey(task.uuid),
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                color: const Color(0xFF10B981),
                child: const Icon(Icons.check),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: const Color(0xFFEF4444),
                child: const Icon(Icons.delete),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  await ref
                      .read(taskNotifierProvider.notifier)
                      .markDone(task.uuid);
                  HapticFeedback.mediumImpact();
                  return false;
                }
                return await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete task?'),
                        content: const Text('This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ) ??
                    false;
              },
              onDismissed: (_) async {
                await ref
                    .read(taskNotifierProvider.notifier)
                    .deleteTask(task.uuid);
              },
              child: ListTile(
                leading: Checkbox(
                  value: task.status == 'done',
                  onChanged: (_) async {
                    await ref
                        .read(taskNotifierProvider.notifier)
                        .moveTask(
                          task.uuid,
                          task.status == 'done' ? 'todo' : 'done',
                        );
                  },
                ),
                title: Text(task.title),
                subtitle: Text(task.tag),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    Text(task.priority.toUpperCase()),
                    if (task.dueDate != null)
                      Text('${task.dueDate!.month}/${task.dueDate!.day}'),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }

  String _title(String status) {
    if (status == 'inprogress') return 'IN PROGRESS';
    if (status == 'done') return 'DONE';
    return 'TO DO';
  }
}
