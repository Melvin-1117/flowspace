import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/focus_lock_session.dart';

Future<List<FocusLockSession>> loadFocusLockSessionsFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonStr = prefs.getString('focus_lock_sessions');
  if (jsonStr == null) return [];
  try {
    final List<dynamic> list = jsonDecode(jsonStr);
    return list.map((item) {
      final map = item as Map<String, dynamic>;
      return FocusLockSession()
        ..id = map['id'] ?? 0
        ..uuid = map['uuid'] ?? ''
        ..durationMinutes = map['durationMinutes'] ?? 0
        ..strikes = map['strikes'] ?? 0
        ..isCompleted = map['isCompleted'] ?? true
        ..isVoid = map['isVoid'] ?? false
        ..startedAt = DateTime.parse(
          map['startedAt'] ?? DateTime.now().toIso8601String(),
        )
        ..completedAt = map['completedAt'] != null
            ? DateTime.parse(map['completedAt'])
            : null
        ..focusScore = map['focusScore'] ?? 0;
    }).toList();
  } catch (e) {
    return [];
  }
}

Future<void> saveFocusLockSessionToPrefs(FocusLockSession session) async {
  final prefs = await SharedPreferences.getInstance();
  final list = await loadFocusLockSessionsFromPrefs();
  list.add(session);
  final jsonStr = jsonEncode(list.map((s) => {
    'id': s.id,
    'uuid': s.uuid,
    'durationMinutes': s.durationMinutes,
    'strikes': s.strikes,
    'isCompleted': s.isCompleted,
    'isVoid': s.isVoid,
    'startedAt': s.startedAt.toIso8601String(),
    'completedAt': s.completedAt?.toIso8601String(),
    'focusScore': s.focusScore,
  }).toList());
  await prefs.setString('focus_lock_sessions', jsonStr);
}

/// Today's focus lock sessions (completed + voided).
final todayFocusLockSessionsProvider =
    FutureProvider<List<FocusLockSession>>((ref) async {
  final all = await loadFocusLockSessionsFromPrefs();
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return all.where((s) => s.startedAt.isAfter(start) && s.startedAt.isBefore(end)).toList();
});

/// All focus lock sessions, sorted newest first.
final allFocusLockSessionsProvider =
    FutureProvider<List<FocusLockSession>>((ref) async {
  final all = await loadFocusLockSessionsFromPrefs();
  all.sort((a, b) => b.startedAt.compareTo(a.startedAt));
  return all;
});
