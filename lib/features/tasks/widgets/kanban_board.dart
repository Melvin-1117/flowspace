import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/task.dart';
import '../providers/task_providers.dart';
import 'kanban_column.dart';

class KanbanBoard extends ConsumerStatefulWidget {
  const KanbanBoard({super.key, required this.tasks, this.maxWidth});

  final List<Task> tasks;

  /// Viewport width from parent [LayoutBuilder] so column width fits mobile.
  final double? maxWidth;

  @override
  ConsumerState<KanbanBoard> createState() => _KanbanBoardState();
}

class _KanbanBoardState extends ConsumerState<KanbanBoard> {
  final List<String> _columns = ['todo', 'inprogress', 'done'];
  final Map<String, String> _columnTitles = {
    'todo': 'To Do',
    'inprogress': 'In Progress',
    'done': 'Done',
  };

  @override
  Widget build(BuildContext context) {
    final grouped = {
      for (final key in _columns)
        key: widget.tasks.where((task) => task.status == key).toList(),
    };

    final viewportW = widget.maxWidth ?? MediaQuery.sizeOf(context).width;
    final isNarrowViewport = viewportW < 760;
    const listGutterSlack = 48.0;
    final listW = ((viewportW - listGutterSlack) / 3).clamp(220.0, 312.0);
    final columnHeight = MediaQuery.sizeOf(context).height * 0.66;
    final mobileColumnHeight = (MediaQuery.sizeOf(context).height * 0.55).clamp(
      320.0,
      520.0,
    );

    if (isNarrowViewport) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        itemCount: _columns.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final status = _columns[index];
          final tasks = grouped[status] ?? <Task>[];
          return SizedBox(
            height: mobileColumnHeight,
            child: KanbanColumn(
              title: _columnTitles[status] ?? status,
              dotColor: _statusColor(status),
              tasks: tasks,
              onMenuTap: () => _showColumnMenu(status),
            ),
          );
        },
      );
    }

    return DragAndDropLists(
      axis: Axis.horizontal,
      listWidth: listW,
      listDraggingWidth: listW,
      listPadding: const EdgeInsets.symmetric(horizontal: 10),
      children: _columns.map((status) {
        final tasks = grouped[status] ?? <Task>[];
        return DragAndDropList(
          canDrag: false,
          header: SizedBox(
            height: columnHeight,
            child: KanbanColumn(
              title: _columnTitles[status] ?? status,
              dotColor: _statusColor(status),
              tasks: tasks,
              onMenuTap: () => _showColumnMenu(status),
              width: listW,
            ),
          ),
          children: [
            for (var i = 0; i < tasks.length; i++)
              DragAndDropItem(canDrag: true, child: const SizedBox.shrink()),
          ],
        );
      }).toList(),
      onItemReorder:
          (oldItemIndex, oldListIndex, newItemIndex, newListIndex) async {
            final fromStatus = _columns[oldListIndex];
            final toStatus = _columns[newListIndex];
            final movedTask = grouped[fromStatus]![oldItemIndex];
            await ref
                .read(taskNotifierProvider.notifier)
                .moveTask(movedTask.uuid, toStatus);
            HapticFeedback.mediumImpact();
          },
      onListReorder: (_, __) {},
      listInnerDecoration: const BoxDecoration(color: Colors.transparent),
      itemDecorationWhileDragging: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 20, color: Color(0x40000000))],
      ),
      listDecorationWhileDragging: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7C3AED)),
      ),
    );
  }

  Future<void> _showColumnMenu(String status) async {
    final mq = MediaQuery.of(context);
    final choice = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        mq.size.width - 220,
        mq.padding.top + kToolbarHeight + 48,
        16,
        mq.size.height - 80,
      ),
      items: const [
        PopupMenuItem(value: 'rename', child: Text('Rename column')),
        PopupMenuItem(value: 'clear', child: Text('Clear all tasks')),
        PopupMenuItem(value: 'add', child: Text('Add new column')),
        PopupMenuItem(value: 'delete', child: Text('Delete column')),
      ],
    );
    if (!mounted) return;
    if (choice == null) return;
    if (choice == 'rename') {
      final controller = TextEditingController(text: _columnTitles[status]);
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Rename column'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _columnTitles[status] = controller.text.trim());
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
      if (!mounted) return;
    } else if (choice == 'clear') {
      final tasks = widget.tasks
          .where((task) => task.status == status)
          .toList();
      final notifier = ref.read(taskNotifierProvider.notifier);
      for (final task in tasks) {
        await notifier.deleteTask(task.uuid);
      }
    } else if (choice == 'add') {
      final controller = TextEditingController();
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Add column'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final id = controller.text.trim().toLowerCase().replaceAll(
                  ' ',
                  '',
                );
                if (id.isNotEmpty && !_columns.contains(id)) {
                  setState(() {
                    _columns.add(id);
                    _columnTitles[id] = controller.text.trim();
                  });
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
      if (!mounted) return;
    } else if (choice == 'delete') {
      if (status == 'todo' || status == 'inprogress' || status == 'done') {
        return;
      }
      setState(() {
        _columns.remove(status);
        _columnTitles.remove(status);
      });
    }
  }

  Color _statusColor(String status) {
    if (status == 'inprogress') return const Color(0xFF06B6D4);
    if (status == 'done') return const Color(0xFF10B981);
    return const Color(0xFF555555);
  }
}
