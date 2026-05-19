import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/milestone.dart';
import '../../../core/models/subject.dart';
import '../../../core/models/subject_module.dart';
import '../providers/planner_providers.dart';
import '../../../app/theme.dart';

class AddSubjectSheet extends StatefulWidget {
  const AddSubjectSheet({required this.onSubmit, super.key});

  final Future<void> Function(Subject subject, Milestone? examMilestone)
  onSubmit;

  @override
  State<AddSubjectSheet> createState() => _AddSubjectSheetState();
}

class _AddSubjectSheetState extends State<AddSubjectSheet> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _modules = 6;
  int _goalHours = 6;
  DateTime? _examDate;
  String _iconName = 'menu_book';
  String _colorHex = '#7C3AED';

  static const _iconChoices = <String>[
    'menu_book',
    'psychology',
    'code',
    'memory',
    'science',
    'calculate',
    'terminal',
    'biotech',
    'functions',
    'school',
    'data_object',
    'api',
  ];

  static const _colors = <String>[
    '#7C3AED',
    '#06B6D4',
    '#10B981',
    '#F59E0B',
    '#EF4444',
    '#EC4899',
  ];

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
                  'Add New Subject',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _nameController,
                  maxLength: 60,
                  decoration: const InputDecoration(
                    labelText: 'Subject name',
                    hintText: 'e.g. Advanced Neural Networks',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Required'
                      : null,
                ),
                const SizedBox(height: 8),
                const Text('Subject Icon'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _iconChoices.map((name) {
                    final selected = _iconName == name;
                    return InkWell(
                      onTap: () => setState(() => _iconName = name),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppTheme.primary.withValues(alpha: 0.2)
                              : AppTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.surfaceBorder,
                          ),
                        ),
                        child: Icon(_iconForName(name), size: 18),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text('Subject Color'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: _colors.map((hex) {
                    final selected = _colorHex == hex;
                    return InkWell(
                      onTap: () => setState(() => _colorHex = hex),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _colorFromHex(hex),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? Colors.white : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text('Total Modules'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(
                        () => _modules = (_modules - 1).clamp(1, 50),
                      ),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$_modules'),
                    IconButton(
                      onPressed: () => setState(
                        () => _modules = (_modules + 1).clamp(1, 50),
                      ),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Exam Date (optional)'),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365),
                      ),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                      initialDate:
                          _examDate ??
                          DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) setState(() => _examDate = picked);
                  },
                  child: Text(
                    _examDate == null
                        ? 'Pick Date'
                        : DateFormat.yMMMd().format(_examDate!),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Weekly Study Goal'),
                Slider(
                  value: _goalHours.toDouble(),
                  min: 1,
                  max: 20,
                  divisions: 19,
                  label: '$_goalHours h/week',
                  onChanged: (value) =>
                      setState(() => _goalHours = value.round()),
                ),
                const SizedBox(height: 12),
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
                        onPressed: _save,
                        child: const Text('Add Subject'),
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final subjectId = const Uuid().v4();
    final modules = List<SubjectModule>.generate(
      _modules,
      (index) => SubjectModule(
        uuid: const Uuid().v4(),
        subjectId: subjectId,
        name: 'Module ${index + 1}',
        moduleNumber: index + 1,
        isCompleted: false,
        completedAt: null,
        linkedNoteIds: const <String>[],
      ),
    );
    final subject = Subject(
      uuid: subjectId,
      name: _nameController.text.trim(),
      iconName: _iconName,
      colorHex: _colorHex,
      totalModules: _modules,
      completedModules: 0,
      examDate: _examDate,
      weeklyGoalHours: _goalHours,
      createdAt: DateTime.now(),
      modules: modules,
    );

    Milestone? examMilestone;
    if (_examDate != null) {
      examMilestone = Milestone(
        uuid: 'exam-$subjectId',
        title: '${subject.name} Exam',
        description: '${subject.name} exam milestone',
        linkedSubjectId: subjectId,
        dueDate: _examDate!,
        priority: plannerPriorityFromRemainingDays(
          _examDate!.difference(DateTime.now()).inDays,
        ),
        isCompleted: false,
        completedAt: null,
        checklistItems: const <String>['Revision', 'Mock test', 'Final review'],
        checklistCompleted: const <bool>[false, false, false],
      );
    }

    await widget.onSubmit(subject, examMilestone);
    if (mounted) Navigator.of(context).pop();
  }
}

IconData _iconForName(String iconName) {
  return switch (iconName) {
    'psychology' => Icons.psychology_alt_outlined,
    'code' => Icons.code,
    'memory' => Icons.memory,
    'science' => Icons.science_outlined,
    'calculate' => Icons.calculate_outlined,
    'terminal' => Icons.terminal,
    'biotech' => Icons.biotech_outlined,
    'functions' => Icons.functions,
    'school' => Icons.school_outlined,
    'data_object' => Icons.data_object,
    'api' => Icons.api,
    _ => Icons.menu_book_outlined,
  };
}

Color _colorFromHex(String hex) {
  final value = hex.replaceFirst('#', '');
  return Color(int.parse('FF$value', radix: 16));
}
