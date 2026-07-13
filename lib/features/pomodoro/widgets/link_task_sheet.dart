import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/error_card.dart';
import '../../planner/providers/planner_providers.dart';
import '../../tasks/providers/task_providers.dart';
import '../providers/pomodoro_providers.dart';

class LinkTaskSheet extends ConsumerWidget {
  const LinkTaskSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusBlocksAsync = ref.watch(todayFocusBlocksProvider);
    final subjectsAsync = ref.watch(allSubjectsProvider);
    final tasksAsync = ref.watch(allTasksProvider);

    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Link Focus Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const TabBar(
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primary,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: 'Focus Blocks'),
                Tab(text: 'Subjects'),
                Tab(text: 'Tasks'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  // Focus Blocks Tab
                  focusBlocksAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => ErrorCard(
                      message: 'Could not load focus blocks',
                      onRetry: () => ref.invalidate(todayFocusBlocksProvider),
                    ),
                    data: (blocks) {
                      final pending = blocks.where((b) => !b.isCompleted).toList();
                      if (pending.isEmpty) {
                        return const _EmptyListPlaceholder(
                          icon: Icons.grid_view_rounded,
                          title: 'No pending blocks',
                          subtitle: 'All focus blocks for today are completed.',
                        );
                      }
                      return ListView.separated(
                        itemCount: pending.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final block = pending[index];
                          return _ListItem(
                            title: block.title,
                            subtitle: '${block.durationMinutes} min • ${block.sessionType}',
                            icon: Icons.calendar_today_outlined,
                            iconColor: AppTheme.primary,
                            onLink: () {
                              ref.read(timerNotifierProvider.notifier).setLinkedTask(block.uuid, block.title);
                              Navigator.pop(context);
                            },
                            onStart: () {
                              ref.read(timerNotifierProvider.notifier).startFocusWithDuration(
                                durationSeconds: block.durationMinutes * 60,
                                linkedTaskId: block.uuid,
                                linkedTaskTitle: block.title,
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),

                  // Subjects Tab
                  subjectsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => ErrorCard(
                      message: 'Could not load subjects',
                      onRetry: () => ref.invalidate(allSubjectsProvider),
                    ),
                    data: (subjects) {
                      if (subjects.isEmpty) {
                        return const _EmptyListPlaceholder(
                          icon: Icons.school_rounded,
                          title: 'No subjects',
                          subtitle: 'Create subjects in the Planner page first.',
                        );
                      }
                      return ListView.separated(
                        itemCount: subjects.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          final color = _colorFromHex(subject.colorHex);
                          return _ListItem(
                            title: subject.name,
                            subtitle: '${(subject.completionPercent * 100).round()}% completed',
                            icon: Icons.menu_book_rounded,
                            iconColor: color,
                            onLink: () {
                              ref.read(timerNotifierProvider.notifier).setLinkedTask(subject.uuid, subject.name);
                              Navigator.pop(context);
                            },
                            onStart: () {
                              ref.read(timerNotifierProvider.notifier).start(
                                linkedTaskId: subject.uuid,
                                linkedTaskTitle: subject.name,
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),

                  // Tasks Tab
                  tasksAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => ErrorCard(
                      message: 'Could not load tasks',
                      onRetry: () => ref.invalidate(allTasksProvider),
                    ),
                    data: (tasks) {
                      final pendingTasks = tasks.where((t) => t.status != 'done').toList();
                      if (pendingTasks.isEmpty) {
                        return const _EmptyListPlaceholder(
                          icon: Icons.check_circle_outline,
                          title: 'No pending tasks',
                          subtitle: 'Add tasks in the Tasks page.',
                        );
                      }
                      return ListView.separated(
                        itemCount: pendingTasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final task = pendingTasks[index];
                          return _ListItem(
                            title: task.title,
                            subtitle: 'Priority: ${task.priority.toUpperCase()}',
                            icon: Icons.assignment_outlined,
                            iconColor: AppTheme.accent,
                            onLink: () {
                              ref.read(timerNotifierProvider.notifier).setLinkedTask(task.uuid, task.title);
                              Navigator.pop(context);
                            },
                            onStart: () {
                              ref.read(timerNotifierProvider.notifier).start(
                                linkedTaskId: task.uuid,
                                linkedTaskTitle: task.title,
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFromHex(String hex) {
    final value = hex.replaceFirst('#', '');
    return Color(int.parse('FF$value', radix: 16));
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onLink,
    required this.onStart,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onLink;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onLink,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Text('Link'),
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: onStart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _EmptyListPlaceholder extends StatelessWidget {
  const _EmptyListPlaceholder({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: AppTheme.textMuted),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
