import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/focus_block.dart';
import '../../../core/models/subject.dart';
import '../../../app/theme.dart';

class AddFocusBlockSheet extends StatefulWidget {
  const AddFocusBlockSheet({
    required this.subjects,
    required this.onSubmit,
    super.key,
  });

  final List<Subject> subjects;
  final Future<void> Function(FocusBlock block) onSubmit;

  @override
  State<AddFocusBlockSheet> createState() => _AddFocusBlockSheetState();
}

class _AddFocusBlockSheetState extends State<AddFocusBlockSheet> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _subjectId;
  String _sessionType = 'deepwork';
  DateTime _scheduledTime = DateTime.now().add(const Duration(hours: 1));
  int _duration = 45;
  String _repeatRule = 'none';
  bool _reminderEnabled = true;
  int _reminderMinutes = 15;

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
                  'Add Focus Block',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Block Title'),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: _subjectId,
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
                DropdownButtonFormField<String>(
                  value: _sessionType,
                  decoration: const InputDecoration(labelText: 'Session Type'),
                  items: const [
                    DropdownMenuItem(
                      value: 'deepwork',
                      child: Text('Deep Work'),
                    ),
                    DropdownMenuItem(value: 'review', child: Text('Review')),
                    DropdownMenuItem(
                      value: 'practice',
                      child: Text('Practice'),
                    ),
                    DropdownMenuItem(value: 'reading', child: Text('Reading')),
                  ],
                  onChanged: (value) => setState(() => _sessionType = value!),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_scheduledTime),
                    );
                    if (picked != null) {
                      setState(() {
                        final now = DateTime.now();
                        _scheduledTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          picked.hour,
                          picked.minute,
                        );
                      });
                    }
                  },
                  child: Text(
                    'Start Time: ${TimeOfDay.fromDateTime(_scheduledTime).format(context)}',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [25, 45, 60, 90, 120].map((minutes) {
                    return ChoiceChip(
                      label: Text('$minutes mins'),
                      selected: _duration == minutes,
                      onSelected: (_) => setState(() => _duration = minutes),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _repeatRule,
                  decoration: const InputDecoration(labelText: 'Repeat'),
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('None')),
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(
                      value: 'weekdays',
                      child: Text('Weekdays'),
                    ),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  ],
                  onChanged: (value) => setState(() => _repeatRule = value!),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: _reminderEnabled,
                  onChanged: (value) =>
                      setState(() => _reminderEnabled = value),
                  title: const Text('Set Reminder'),
                ),
                if (_reminderEnabled)
                  Wrap(
                    spacing: 8,
                    children: [5, 10, 15, 30, 60].map((minutes) {
                      return ChoiceChip(
                        label: Text('$minutes min before'),
                        selected: _reminderMinutes == minutes,
                        onSelected: (_) =>
                            setState(() => _reminderMinutes = minutes),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 16),
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
                        child: const Text('Add Block'),
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
    final block = FocusBlock(
      uuid: const Uuid().v4(),
      title: _titleController.text.trim(),
      linkedSubjectId: _subjectId,
      linkedTaskId: _subjectId,
      sessionType: _sessionType,
      scheduledTime: _scheduledTime,
      durationMinutes: _duration,
      isCompleted: false,
      completedAt: null,
      repeatRule: _repeatRule,
      reminderEnabled: _reminderEnabled,
      reminderMinutesBefore: _reminderMinutes,
    );
    await widget.onSubmit(block);
    if (mounted) Navigator.of(context).pop();
  }
}
