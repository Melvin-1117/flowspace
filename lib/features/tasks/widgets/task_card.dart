import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/animation_tokens.dart';
import '../../../core/models/task.dart';
import '../providers/task_providers.dart';
import 'dependency_manager.dart';
import 'edit_task_sheet.dart';
import 'priority_popover.dart';

class TaskCard extends ConsumerWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue =
        task.dueDate != null &&
        task.dueDate!.isBefore(DateTime.now()) &&
        task.status != 'done';
    final selected = ref.watch(selectedTasksProvider);
    final multiSelectMode = selected.isNotEmpty;
    final isSelected = selected.contains(task.uuid);

    return GestureDetector(
      onLongPress: () {
        ref.read(selectedTasksProvider.notifier).state = [task.uuid];
      },
      onTap: () {
        if (multiSelectMode) {
          final next = [...selected];
          if (isSelected) {
            next.remove(task.uuid);
          } else {
            next.add(task.uuid);
          }
          ref.read(selectedTasksProvider.notifier).state = next;
          return;
        }
        context.push('/tasks/${task.uuid}');
      },
      child: AnimatedContainer(
        duration: kMicroDuration,
        curve: kMicroCurve,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: isOverdue ? const Color(0xFFEF4444) : Colors.transparent,
              width: 3,
            ),
            top: const BorderSide(color: Color(0x22FFFFFF)),
            right: const BorderSide(color: Color(0x22FFFFFF)),
            bottom: const BorderSide(color: Color(0x22FFFFFF)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    final filters = ref.read(activeFiltersProvider);
                    ref.read(activeFiltersProvider.notifier).state = filters
                        .copyWith(tags: {task.tag});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF262626)),
                    ),
                    child: Text(
                      task.tag.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (multiSelectMode)
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) {
                      final next = [...selected];
                      if (isSelected) {
                        next.remove(task.uuid);
                      } else {
                        next.add(task.uuid);
                      }
                      ref.read(selectedTasksProvider.notifier).state = next;
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color(0xFF0D0D0D),
                      builder: (_) => EditTaskSheet(task: task),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF0F0F0),
              ),
            ),
            if (task.description.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF555555), fontSize: 13),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    final picked = await showPriorityPopover(
                      context,
                      task.priority,
                    );
                    if (picked == null) return;
                    await ref
                        .read(taskNotifierProvider.notifier)
                        .updatePriority(task.uuid, picked);
                  },
                  child: _PriorityBadge(priority: task.priority),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: const Color(0xFF0D0D0D),
                      builder: (_) => DependencyManager(task: task),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${task.dependencyIds.length} deps'),
                  ),
                ),
                const Spacer(),
                if (task.dueDate != null)
                  Text(
                    '${task.dueDate!.month}/${task.dueDate!.day}',
                    style: TextStyle(
                      color: isOverdue
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF555555),
                    ),
                  ),
              ],
            ),
            if (task.status == 'done')
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                  },
                  child: const Text('Completed'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    late IconData icon;
    late Color color;
    late String label;
    switch (priority) {
      case 'high':
        icon = Icons.priority_high;
        color = const Color(0xFFEF4444);
        label = 'High';
      case 'low':
        icon = Icons.arrow_downward;
        color = const Color(0xFF10B981);
        label = 'Low';
      default:
        icon = Icons.drag_handle;
        color = const Color(0xFFF59E0B);
        label = 'Med';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
