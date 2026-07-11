import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/milestone.dart';
import '../../../core/models/subject.dart';
import '../../../app/theme.dart';
import '../providers/planner_providers.dart';

class AddMilestoneSheet extends StatefulWidget {
  const AddMilestoneSheet({
    required this.subjects,
    required this.onSubmit,
    super.key,
  });

  final List<Subject> subjects;
  final Future<void> Function(Milestone milestone) onSubmit;

  @override
  State<AddMilestoneSheet> createState() => _AddMilestoneSheetState();
}

class _AddMilestoneSheetState extends State<AddMilestoneSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _checklistController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _subjectId;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  final List<String> _checklistItems = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _checklistController.dispose();
    super.dispose();
  }

  void _addChecklistItem() {
    final text = _checklistController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _checklistItems.add(text);
        _checklistController.clear();
      });
    }
  }

  void _removeChecklistItem(int index) {
    setState(() {
      _checklistItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Milestone',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Milestone Title',
                    hintText: 'e.g. Midterm Project Submission',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'e.g. Submit reports and source code link',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: _subjectId,
                  decoration: const InputDecoration(
                    labelText: 'Linked Subject',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...widget.subjects.map(
                      (subject) => DropdownMenuItem<String?>(
                        value: subject.uuid,
                        child: Text(subject.name),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _subjectId = value),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Due Date',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                      initialDate: _dueDate,
                    );
                    if (picked != null) {
                      setState(() {
                        _dueDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          23,
                          59,
                        );
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today_outlined, size: 16),
                  label: Text(DateFormat.yMMMd().format(_dueDate)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Preparation Checklist',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _checklistController,
                        decoration: const InputDecoration(
                          hintText: 'Add preparation step...',
                          isDense: true,
                        ),
                        onSubmitted: (_) => _addChecklistItem(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppTheme.primary),
                      onPressed: _addChecklistItem,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_checklistItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No checklist items yet.',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _checklistItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: const Icon(Icons.circle_outlined, size: 16, color: AppTheme.textMuted),
                        title: Text(
                          _checklistItems[index],
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 18, color: AppTheme.danger),
                          onPressed: () => _removeChecklistItem(index),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                        ),
                        onPressed: _submit,
                        child: const Text('Add Milestone'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final milestone = Milestone(
      uuid: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      linkedSubjectId: _subjectId,
      dueDate: _dueDate,
      priority: plannerPriorityFromRemainingDays(
        _dueDate.difference(DateTime.now()).inDays,
      ),
      isCompleted: false,
      completedAt: null,
      checklistItems: _checklistItems,
      checklistCompleted: List<bool>.filled(_checklistItems.length, false),
    );
    
    await widget.onSubmit(milestone);
    if (mounted) Navigator.of(context).pop();
  }
}
