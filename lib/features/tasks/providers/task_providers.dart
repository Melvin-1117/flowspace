import 'package:flutter/material.dart';

@immutable
class ViewMode {
  final bool kanban;
  const ViewMode(this.kanban);
  static const ViewMode kanbanMode = ViewMode(true);
  static const ViewMode listMode = ViewMode(false);
}

class TaskFilters {
  final List<String> priority;
  final List<String> tags;
  final List<String> status;

  TaskFilters({
    this.priority = const [],
    this.tags = const [],
    this.status = const [],
  });
}
