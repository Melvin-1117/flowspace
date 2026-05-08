import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/milestone.dart';

class MilestoneDetailSheet extends StatelessWidget {
  const MilestoneDetailSheet({
    required this.milestone,
    required this.onToggleChecklist,
    required this.onComplete,
    required this.onEdit,
    super.key,
  });

  final Milestone milestone;
  final Future<void> Function(int index, bool value) onToggleChecklist;
  final Future<void> Function() onComplete;
  final Future<void> Function(
    String title,
    String description,
    DateTime dueDate,
  )
  onEdit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              milestone.title,
              style: const TextStyle(
                color: Color(0xFFF0F0F0),
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              milestone.description,
              style: const TextStyle(color: Color(0xFF555555)),
            ),
            const SizedBox(height: 8),
            Text(
              'Due ${DateFormat.yMMMd().format(milestone.dueDate)}',
              style: const TextStyle(color: Color(0xFF555555)),
            ),
            const SizedBox(height: 12),
            ...List.generate(milestone.checklistItems.length, (index) {
              final checked = index < milestone.checklistCompleted.length
                  ? milestone.checklistCompleted[index]
                  : false;
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: checked,
                activeColor: const Color(0xFF7C3AED),
                title: Text(
                  milestone.checklistItems[index],
                  style: const TextStyle(color: Color(0xFFF0F0F0)),
                ),
                onChanged: (value) {
                  if (value != null) {
                    onToggleChecklist(index, value);
                  }
                },
              );
            }),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () async {
                await onComplete();
                if (context.mounted) Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Mark as complete'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                final edited = await _showEditDialog(context);
                if (edited == null) return;
                await onEdit(edited.$1, edited.$2, edited.$3);
                if (context.mounted) Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
              child: const Text('Edit milestone'),
            ),
          ],
        ),
      ),
    );
  }

  Future<(String, String, DateTime)?> _showEditDialog(
    BuildContext context,
  ) async {
    final titleController = TextEditingController(text: milestone.title);
    final descriptionController = TextEditingController(
      text: milestone.description,
    );
    var dueDate = milestone.dueDate;
    return showDialog<(String, String, DateTime)>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0D0D0D),
              title: const Text('Edit Milestone'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                        initialDate: dueDate,
                      );
                      if (picked != null) {
                        setState(() {
                          dueDate = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            dueDate.hour,
                            dueDate.minute,
                          );
                        });
                      }
                    },
                    child: Text(DateFormat.yMMMd().format(dueDate)),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop((
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                    dueDate,
                  )),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
