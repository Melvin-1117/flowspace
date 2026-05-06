import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/models/task.dart';
import '../../core/models/task_activity.dart';
import '../../core/models/pomodoro_session.dart';
import '../../core/providers/session_timer_provider.dart';
import '../../widgets/app_drawer.dart';
import '../pomodoro/providers/pomodoro_providers.dart';
import 'providers/task_providers.dart';
import 'widgets/dependency_manager.dart';
import 'widgets/subtask_list.dart';

class TaskDetailScreen extends ConsumerWidget {
  TaskDetailScreen({super.key, required this.taskId});

  final String taskId;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskNotifierProvider).valueOrNull ?? <Task>[];
    final task = tasks.where((item) => item.uuid == taskId).firstOrNull;
    if (task == null) {
      return const Scaffold(body: Center(child: Text('Task not found')));
    }

    final activities =
        ref.watch(taskActivitiesProvider)[taskId] ?? <TaskActivity>[];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF000000),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Task Detail'),
      ),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            TextFormField(
              initialValue: task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(border: InputBorder.none),
              onFieldSubmitted: (value) async {
                await ref
                    .read(taskNotifierProvider.notifier)
                    .updateTask(task.copyWith(title: value));
              },
            ),
            TextFormField(
              initialValue: task.description,
              minLines: 2,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Description'),
              onFieldSubmitted: (value) async {
                await ref
                    .read(taskNotifierProvider.notifier)
                    .updateTask(task.copyWith(description: value));
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(label: Text('Tag: ${task.tag}'), onPressed: () {}),
                ActionChip(
                  label: Text('Priority: ${task.priority.toUpperCase()}'),
                  onPressed: () {},
                ),
                ActionChip(
                  label: Text(
                    task.dueDate == null
                        ? 'Due: none'
                        : 'Due: ${DateFormat('EEE, MMM d').format(task.dueDate!)}',
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                      initialDate: task.dueDate ?? DateTime.now(),
                    );
                    if (picked == null) return;
                    await ref
                        .read(taskNotifierProvider.notifier)
                        .updateTask(task.copyWith(dueDate: picked));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Subtasks',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            SubtaskList(task: task),
            const SizedBox(height: 16),
            const Text(
              'Dependencies',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: const Color(0xFF0D0D0D),
                  builder: (_) => DependencyManager(task: task),
                );
              },
              child: Text('${task.dependencyIds.length} dependencies'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pomodoro sessions',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Start Focus Session'),
              trailing: const Icon(Icons.play_arrow),
              onTap: () async {
                final settings = await ref.read(
                  focusGoalSettingsProvider.future,
                );
                final session = PomodoroSession()
                  ..uuid = ''
                  ..sessionType = 'focus'
                  ..linkedTaskId = task.uuid
                  ..linkedTaskTitle = task.title
                  ..startTime = DateTime.now()
                  ..plannedDurationSeconds = settings.focusDuration
                  ..actualDurationSeconds = 0
                  ..isCompleted = false
                  ..isAbandoned = false;
                await ref
                    .read(sessionTimerProvider.notifier)
                    .startTimer(session);
                if (!context.mounted) return;
                context.go('/focus');
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Created ${DateFormat('MMM d, y HH:mm').format(task.createdAt)}',
              style: const TextStyle(color: Color(0xFF555555)),
            ),
            Text(
              'Modified ${DateFormat('MMM d, y HH:mm').format(task.updatedAt)}',
              style: const TextStyle(color: Color(0xFF555555)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Activity',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            for (final activity in activities.reversed)
              ListTile(
                dense: true,
                title: Text(activity.description),
                subtitle: Text(
                  DateFormat('MMM d, HH:mm').format(activity.timestamp),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
              ),
              onPressed: () async {
                await ref
                    .read(taskNotifierProvider.notifier)
                    .deleteTask(task.uuid);
                if (context.mounted) context.pop();
              },
              child: const Text('Delete Task'),
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
