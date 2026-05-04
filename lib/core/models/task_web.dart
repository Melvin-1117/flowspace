class Task {
  int id = 0;
  late String uuid;
  late String title;
  late String description;
  late String tag;
  late String priority; // 'high', 'med', 'low'
  late String status; // 'todo', 'inprogress', 'done'
  DateTime? dueDate;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isRecurring;
  late String recurringFrequency; // 'daily', 'weekly', 'monthly'
  late bool assignToPomodoro;
  late List<String> subtasks;
  late List<bool> subtaskCompleted;
  late List<String> dependencyIds;
  late String projectId;
  late int pomodoroCount = 0;
  late int pomodoroTarget = 4;

  bool get isCompleted => status == 'done';
  set isCompleted(bool value) => status = value ? 'done' : 'todo';

  Task copyWith({
    String? uuid,
    String? title,
    String? description,
    String? tag,
    String? priority,
    String? status,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRecurring,
    String? recurringFrequency,
    bool? assignToPomodoro,
    List<String>? subtasks,
    List<bool>? subtaskCompleted,
    List<String>? dependencyIds,
    String? projectId,
    int? pomodoroCount,
    int? pomodoroTarget,
  }) {
    return Task()
      ..id = id
      ..uuid = uuid ?? this.uuid
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..tag = tag ?? this.tag
      ..priority = priority ?? this.priority
      ..status = status ?? this.status
      ..dueDate = dueDate ?? this.dueDate
      ..createdAt = createdAt ?? this.createdAt
      ..updatedAt = updatedAt ?? this.updatedAt
      ..isRecurring = isRecurring ?? this.isRecurring
      ..recurringFrequency = recurringFrequency ?? this.recurringFrequency
      ..assignToPomodoro = assignToPomodoro ?? this.assignToPomodoro
      ..subtasks = subtasks ?? List<String>.from(this.subtasks)
      ..subtaskCompleted =
          subtaskCompleted ?? List<bool>.from(this.subtaskCompleted)
      ..dependencyIds = dependencyIds ?? List<String>.from(this.dependencyIds)
      ..projectId = projectId ?? this.projectId
      ..pomodoroCount = pomodoroCount ?? this.pomodoroCount
      ..pomodoroTarget = pomodoroTarget ?? this.pomodoroTarget;
  }
}
