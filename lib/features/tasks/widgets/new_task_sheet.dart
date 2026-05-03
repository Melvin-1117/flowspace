import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/models/task.dart';
import '../providers/task_providers.dart';

class NewTaskSheet extends ConsumerStatefulWidget {
  const NewTaskSheet({super.key, this.editingTask});

  final Task? editingTask;

  @override
  ConsumerState<NewTaskSheet> createState() => _NewTaskSheetState();
}

class _NewTaskSheetState extends ConsumerState<NewTaskSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _customTagController;
  final List<TextEditingController> _subtaskControllers = [];
  final List<String> _tags = [
    'Frontend',
    'Backend',
    'UI Design',
    'Testing',
    'DevOps',
    'Research',
    'Documentation',
    'Other',
  ];

  String _tag = 'Frontend';
  String _priority = 'med';
  DateTime? _dueDate;
  bool _assignPomodoro = false;
  bool _recurring = false;
  String _frequency = 'daily';
  final List<String> _dependencies = [];

  @override
  void initState() {
    super.initState();
    final task = widget.editingTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _customTagController = TextEditingController();
    _tag = task?.tag ?? 'Frontend';
    _priority = task?.priority ?? 'med';
    _dueDate = task?.dueDate;
    _assignPomodoro = task?.assignToPomodoro ?? false;
    _recurring = task?.isRecurring ?? false;
    _frequency = task?.recurringFrequency ?? 'daily';
    _dependencies.addAll(task?.dependencyIds ?? []);
    final subtasks = task?.subtasks ?? [];
    for (final subtask in subtasks) {
      _subtaskControllers.add(TextEditingController(text: subtask));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _customTagController.dispose();
    for (final c in _subtaskControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = ref.watch(taskNotifierProvider).valueOrNull ?? <Task>[];
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      builder: (context, scrollController) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.viewInsetsOf(context).bottom + 10,
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF555555),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.editingTask == null ? 'New Task' : 'Edit Task',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    TextField(
                      controller: _titleController,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        labelText: 'Task Title *',
                        hintText: 'What needs to be done?',
                      ),
                    ),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Add more details...',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Tag / Category'),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final value in _tags)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                selectedColor: const Color(0xFF7C3AED),
                                label: Text(value),
                                selected: _tag == value,
                                onSelected: (_) => setState(() => _tag = value),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customTagController,
                            decoration: const InputDecoration(
                              hintText: 'Custom tag',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final value = _customTagController.text.trim();
                            if (value.isEmpty) return;
                            setState(() {
                              if (!_tags.contains(value)) _tags.add(value);
                              _tag = value;
                              _customTagController.clear();
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Priority'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _priorityButton('high', const Color(0xFFEF4444)),
                        const SizedBox(width: 8),
                        _priorityButton('med', const Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        _priorityButton('low', const Color(0xFF10B981)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: const Text('Due Date'),
                      subtitle: Text(
                        _dueDate == null
                            ? 'None'
                            : DateFormat('EEE, MMM d').format(_dueDate!),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2024),
                                lastDate: DateTime(2100),
                                initialDate: _dueDate ?? DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() => _dueDate = picked);
                              }
                            },
                            icon: const Icon(Icons.calendar_today),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _dueDate = null),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Subtasks'),
                        const Spacer(),
                        TextButton(
                          onPressed: _subtaskControllers.length >= 10
                              ? null
                              : () {
                                  setState(
                                    () => _subtaskControllers.add(
                                      TextEditingController(),
                                    ),
                                  );
                                },
                          child: const Text('+ Add Subtask'),
                        ),
                      ],
                    ),
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _subtaskControllers.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex--;
                          final item = _subtaskControllers.removeAt(oldIndex);
                          _subtaskControllers.insert(newIndex, item);
                        });
                      },
                      itemBuilder: (context, index) => ListTile(
                        key: ValueKey(_subtaskControllers[index]),
                        title: TextField(
                          controller: _subtaskControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Subtask ${index + 1}',
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              _subtaskControllers[index].dispose();
                              _subtaskControllers.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Dependencies'),
                    for (final task in allTasks.where(
                      (t) => t.uuid != widget.editingTask?.uuid,
                    ))
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _dependencies.contains(task.uuid),
                        onChanged: (selected) {
                          setState(() {
                            if (selected ?? false) {
                              _dependencies.add(task.uuid);
                            } else {
                              _dependencies.remove(task.uuid);
                            }
                          });
                        },
                        title: Text(task.title),
                      ),
                    SwitchListTile(
                      value: _assignPomodoro,
                      onChanged: (value) =>
                          setState(() => _assignPomodoro = value),
                      title: const Text('Assign to Pomodoro'),
                    ),
                    SwitchListTile(
                      value: _recurring,
                      onChanged: (value) => setState(() => _recurring = value),
                      title: const Text('Recurring Task'),
                    ),
                    if (_recurring)
                      DropdownButtonFormField<String>(
                        initialValue: _frequency,
                        items: const [
                          DropdownMenuItem(
                            value: 'daily',
                            child: Text('Daily'),
                          ),
                          DropdownMenuItem(
                            value: 'weekly',
                            child: Text('Weekly'),
                          ),
                          DropdownMenuItem(
                            value: 'monthly',
                            child: Text('Monthly'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => _frequency = value ?? 'daily'),
                      ),
                  ],
                ),
              ),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                      ),
                      onPressed: () async {
                        final title = _titleController.text.trim();
                        if (title.isEmpty) return;
                        final notifier = ref.read(
                          taskNotifierProvider.notifier,
                        );
                        if (widget.editingTask != null) {
                          await notifier.updateTask(
                            widget.editingTask!.copyWith(
                              title: title,
                              description: _descriptionController.text.trim(),
                              tag: _tag,
                              priority: _priority,
                              dueDate: _dueDate,
                              isRecurring: _recurring,
                              recurringFrequency: _frequency,
                              assignToPomodoro: _assignPomodoro,
                              subtasks: _subtaskControllers
                                  .map((controller) => controller.text.trim())
                                  .where((value) => value.isNotEmpty)
                                  .toList(),
                              subtaskCompleted: List.filled(
                                _subtaskControllers
                                    .map((controller) => controller.text.trim())
                                    .where((value) => value.isNotEmpty)
                                    .length,
                                false,
                              ),
                              dependencyIds: _dependencies,
                            ),
                          );
                        } else {
                          final project = ref.read(projectProvider).valueOrNull;
                          if (project == null) return;
                          await notifier.addTask(
                            notifier.makeTask(
                              title: title,
                              description: _descriptionController.text.trim(),
                              tag: _tag,
                              priority: _priority,
                              dueDate: _dueDate,
                              isRecurring: _recurring,
                              recurringFrequency: _frequency,
                              assignToPomodoro: _assignPomodoro,
                              subtasks: _subtaskControllers
                                  .map((controller) => controller.text.trim())
                                  .where((value) => value.isNotEmpty)
                                  .toList(),
                              subtaskCompleted: List.filled(
                                _subtaskControllers
                                    .map((controller) => controller.text.trim())
                                    .where((value) => value.isNotEmpty)
                                    .length,
                                false,
                              ),
                              dependencyIds: _dependencies,
                              projectId: project.uuid,
                            ),
                          );
                        }
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: Text(
                        widget.editingTask == null
                            ? 'Create Task'
                            : 'Save Task',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityButton(String value, Color color) {
    final selected = _priority == value;
    return Expanded(
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: selected ? color : const Color(0xFF1A1A1A),
        ),
        onPressed: () => setState(() => _priority = value),
        child: Text(value.toUpperCase()),
      ),
    );
  }
}
