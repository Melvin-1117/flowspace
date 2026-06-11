import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/isar_provider.dart';
import '../models/skill_entry_isar.dart';
import 'devtrack_providers.dart';

class SkillNotifier extends AsyncNotifier<List<SkillEntry>> {
  @override
  Future<List<SkillEntry>> build() async {
    final isar = await ref.read(isarProvider.future);
    return isar
        .collection<SkillEntry>()
        .where()
        .sortByHoursInvestedDesc()
        .findAll();
  }

  Future<void> addSkill(SkillEntry s) async {
    final isar = await ref.read(isarProvider.future);
    s.uuid = const Uuid().v4();
    await isar.writeTxn(() => isar.collection<SkillEntry>().put(s));
    ref.invalidate(allSkillsProvider);
    ref.invalidateSelf();
  }

  Future<void> updateSkill(SkillEntry s) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() => isar.collection<SkillEntry>().put(s));
    ref.invalidate(allSkillsProvider);
    ref.invalidateSelf();
  }

  Future<void> deleteSkill(String uuid) async {
    final isar = await ref.read(isarProvider.future);
    final skill = await isar
        .collection<SkillEntry>()
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    if (skill != null) {
      await isar.writeTxn(() => isar.collection<SkillEntry>().delete(skill.id));
    }
    ref.invalidate(allSkillsProvider);
    ref.invalidateSelf();
  }

  Future<void> incrementHours(String uuid, int mins) async {
    final isar = await ref.read(isarProvider.future);
    final skill = await isar
        .collection<SkillEntry>()
        .filter()
        .uuidEqualTo(uuid)
        .findFirst();
    if (skill != null) {
      skill.hoursInvested += (mins ~/ 60);
      skill.lastPracticedAt = DateTime.now();
      await isar.writeTxn(() => isar.collection<SkillEntry>().put(skill));
    }
    ref.invalidate(allSkillsProvider);
    ref.invalidateSelf();
  }
}

final skillNotifierProvider =
    AsyncNotifierProvider<SkillNotifier, List<SkillEntry>>(
  SkillNotifier.new,
);
