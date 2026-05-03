import 'package:flutter/material.dart';
import '../../../core/models/task.dart';
import 'task_card.dart';

class KanbanColumn extends StatelessWidget {
  const KanbanColumn({
    super.key,
    required this.title,
    required this.dotColor,
    required this.tasks,
    required this.onMenuTap,
    this.width,
  });

  final String title;
  final Color dotColor;
  final List<Task> tasks;
  final VoidCallback onMenuTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 10,
                backgroundColor: const Color(0xFF1A1A1A),
                child: Text(
                  '${tasks.length}',
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onMenuTap,
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tasks.isEmpty
                ? _EmptyState(title: title)
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) =>
                        TaskCard(task: tasks[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x44FFFFFF),
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.inbox_outlined, color: Color(0xFF555555)),
              SizedBox(height: 8),
              Text(
                'No tasks here — drag one or add new',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF555555)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
