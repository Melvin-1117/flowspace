import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/skill_entry.dart';
import 'devtrack_providers.dart';

class SkillNotifier extends AsyncNotifier<List<SkillEntry>> {
  @override
  Future<List<SkillEntry>> build() async {
    return _loadSkills();
  }

  Future<List<SkillEntry>> _loadSkills() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('devtrack_skills');
    if (jsonStr == null) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonStr);
      return list.map((item) {
        final map = item as Map<String, dynamic>;
        return SkillEntry()
          ..id = map['id'] ?? 0
          ..uuid = map['uuid'] ?? ''
          ..skillName = map['skillName'] ?? ''
          ..category = map['category'] ?? ''
          ..proficiencyLevel = map['proficiencyLevel'] ?? 1
          ..hoursInvested = map['hoursInvested'] ?? 0
          ..firstLearnedAt = DateTime.parse(
            map['firstLearnedAt'] ?? DateTime.now().toIso8601String(),
          )
          ..lastPracticedAt = DateTime.parse(
            map['lastPracticedAt'] ?? DateTime.now().toIso8601String(),
          )
          ..linkedProjectIds = List<String>.from(map['linkedProjectIds'] ?? [])
          ..notes = map['notes'] ?? '';
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveSkills(List<SkillEntry> skills) async {
    final prefs = await SharedPreferences.getInstance();
    final list = skills
        .map(
          (s) => {
            'id': s.id,
            'uuid': s.uuid,
            'skillName': s.skillName,
            'category': s.category,
            'proficiencyLevel': s.proficiencyLevel,
            'hoursInvested': s.hoursInvested,
            'firstLearnedAt': s.firstLearnedAt.toIso8601String(),
            'lastPracticedAt': s.lastPracticedAt.toIso8601String(),
            'linkedProjectIds': s.linkedProjectIds,
            'notes': s.notes,
          },
        )
        .toList();
    await prefs.setString('devtrack_skills', jsonEncode(list));
  }

  Future<void> addSkill(SkillEntry s) async {
    s.uuid = const Uuid().v4();
    s.firstLearnedAt = DateTime.now();
    s.lastPracticedAt = DateTime.now();
    final current = await _loadSkills();
    current.add(s);
    current.sort((a, b) => b.hoursInvested.compareTo(a.hoursInvested));
    await _saveSkills(current);
    state = AsyncData(current);
    ref.invalidate(allSkillsProvider);
  }

  Future<void> updateSkill(SkillEntry s) async {
    final current = await _loadSkills();
    final index = current.indexWhere((item) => item.uuid == s.uuid);
    if (index >= 0) {
      current[index] = s;
      current.sort((a, b) => b.hoursInvested.compareTo(a.hoursInvested));
      await _saveSkills(current);
      state = AsyncData(current);
      ref.invalidate(allSkillsProvider);
    }
  }

  Future<void> deleteSkill(String uuid) async {
    final current = await _loadSkills();
    current.removeWhere((item) => item.uuid == uuid);
    await _saveSkills(current);
    state = AsyncData(current);
    ref.invalidate(allSkillsProvider);
  }

  Future<void> incrementHours(String uuid, int mins) async {
    final current = await _loadSkills();
    final index = current.indexWhere((item) => item.uuid == uuid);
    if (index >= 0) {
      final skill = current[index];
      skill.hoursInvested += (mins ~/ 60);
      skill.lastPracticedAt = DateTime.now();
      current.sort((a, b) => b.hoursInvested.compareTo(a.hoursInvested));
      await _saveSkills(current);
      state = AsyncData(current);
      ref.invalidate(allSkillsProvider);
    }
  }
}

final skillNotifierProvider =
    AsyncNotifierProvider<SkillNotifier, List<SkillEntry>>(SkillNotifier.new);
