import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/task.dart';
import '../providers/task_providers.dart';

class SubtaskList extends ConsumerWidget {
  const SubtaskList({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (task.subtasks.isEmpty) {
      return const Text('No subtasks');
    }
    return Column(
      children: [
        for (var i = 0; i < task.subtasks.length; i++)
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: i < task.subtaskCompleted.length
                ? task.subtaskCompleted[i]
                : false,
            onChanged: (_) {
              ref
                  .read(taskNotifierProvider.notifier)
                  .toggleSubtask(task.uuid, i);
            },
            title: Text(task.subtasks[i]),
          ),
      ],
    );
  }
}
