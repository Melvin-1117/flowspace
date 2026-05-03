import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/pomodoro_session.dart';
import '../models/project.dart';
import '../models/study_event.dart';
import '../models/task.dart';
import '../models/task_activity.dart';

const _isarName = 'flowspace';

final isarProvider = FutureProvider<Isar>((ref) async {
  final existing = Isar.getInstance(_isarName);
  if (existing != null) return existing;

  final directory = await getApplicationDocumentsDirectory();
  return Isar.open(
    [
      TaskSchema,
      ProjectSchema,
      TaskActivitySchema,
      PomodoroSessionSchema,
      StudyEventSchema,
    ],
    name: _isarName,
    directory: directory.path,
    inspector: false,
  );
});
