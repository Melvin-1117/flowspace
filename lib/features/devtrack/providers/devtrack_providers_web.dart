import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/coding_session.dart';
import '../models/day_activity_data.dart';
import '../models/dev_project.dart';
import '../models/skill_entry.dart';

final allProjectsProvider = FutureProvider<List<DevProject>>((_) async => []);
final activeProjectsProvider = FutureProvider<List<DevProject>>((_) async => []);
final allCodingSessionsProvider = FutureProvider<List<CodingSession>>((_) async => []);
final todayCodingSessionsProvider = FutureProvider<List<CodingSession>>((_) async => []);
final devtrackLanguageDistributionProvider = FutureProvider<Map<String, double>>((_) async => {});
final activityHeatmapProvider = FutureProvider<List<DayActivityData>>((_) async => []);
final allSkillsProvider = FutureProvider<List<SkillEntry>>((_) async => []);
final codingStreakProvider = FutureProvider<int>((_) async => 0);
final totalCodingHoursProvider = FutureProvider<double>((_) async => 0.0);
