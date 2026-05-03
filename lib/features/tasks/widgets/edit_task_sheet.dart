import 'package:flutter/material.dart';
import '../../../core/models/task.dart';
import 'new_task_sheet.dart';

class EditTaskSheet extends StatelessWidget {
  const EditTaskSheet({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return NewTaskSheet(editingTask: task);
  }
}
