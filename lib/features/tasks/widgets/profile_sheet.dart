import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_providers.dart';
import '../../../app/theme.dart';

class ProfileSheet extends ConsumerWidget {
  const ProfileSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final doneCount = (ref.watch(taskNotifierProvider).valueOrNull ?? [])
        .where((task) => task.status == 'done')
        .length;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.surfaceElevated,
              child: Text(
                user.avatarInitials,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(user.email, style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Streak ${user.streakDays} days')),
                Chip(label: Text('Completed $doneCount tasks')),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Edit profile'),
            ),
          ],
        ),
      ),
    );
  }
}
