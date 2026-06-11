import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/skill_entry.dart';

class SkillNotifier extends AsyncNotifier<List<SkillEntry>> {
  @override
  Future<List<SkillEntry>> build() async => [];

  Future<void> addSkill(SkillEntry s) async {}
  Future<void> updateSkill(SkillEntry s) async {}
  Future<void> deleteSkill(String uuid) async {}
  Future<void> incrementHours(String uuid, int mins) async {}
}

final skillNotifierProvider =
    AsyncNotifierProvider<SkillNotifier, List<SkillEntry>>(
  SkillNotifier.new,
);
