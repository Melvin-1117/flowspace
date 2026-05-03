import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pomodoro_session.dart';

final sessionsByDateProvider =
    FutureProvider.family<List<PomodoroSession>, DateTime>((_, __) async => []);

final streakDaysProvider =
    FutureProvider<List<DateTime>>((_) async => []);
