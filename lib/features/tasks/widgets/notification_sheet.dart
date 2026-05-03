import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/task_providers.dart';

class NotificationSheet extends ConsumerWidget {
  const NotificationSheet({super.key, required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (notifications.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text('No notifications')),
      );
    }
    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) {
              ref
                  .read(taskNotifierProvider.notifier)
                  .dismissNotification(item.id);
            },
            background: Container(
              alignment: Alignment.centerLeft,
              color: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.only(left: 16),
              child: const Icon(Icons.done),
            ),
            child: ListTile(
              leading: Icon(_iconFor(item.type), color: _colorFor(item.type)),
              title: Text(item.title),
              subtitle: Text(
                '${item.subtitle} • ${DateFormat('MMM d, HH:mm').format(item.timestamp)}',
              ),
              onTap: () {
                context.pop();
                context.push('/tasks/${item.taskId}');
              },
            ),
          );
        },
      ),
    );
  }

  IconData _iconFor(String type) {
    if (type == 'overdue') return Icons.warning_amber;
    if (type == 'completed') return Icons.celebration;
    if (type == 'unblocked') return Icons.link_off;
    return Icons.schedule;
  }

  Color _colorFor(String type) {
    if (type == 'overdue') return const Color(0xFFEF4444);
    if (type == 'completed') return const Color(0xFF10B981);
    if (type == 'unblocked') return const Color(0xFF06B6D4);
    return const Color(0xFF7C3AED);
  }
}
