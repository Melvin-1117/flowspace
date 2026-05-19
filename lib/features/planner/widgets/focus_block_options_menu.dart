import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class FocusBlockOptionsMenu extends StatelessWidget {
  const FocusBlockOptionsMenu({
    required this.onStartNow,
    required this.onEdit,
    required this.onDelete,
    required this.onComplete,
    super.key,
  });

  final VoidCallback onStartNow;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.play_arrow),
            title: const Text('Start Focus Now'),
            onTap: () {
              Navigator.of(context).pop();
              onStartNow();
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit Block'),
            onTap: () {
              Navigator.of(context).pop();
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: AppTheme.danger),
            title: const Text(
              'Delete Block',
              style: TextStyle(color: AppTheme.danger),
            ),
            onTap: () {
              Navigator.of(context).pop();
              onDelete();
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Mark Complete'),
            onTap: () {
              Navigator.of(context).pop();
              onComplete();
            },
          ),
        ],
      ),
    );
  }
}
