import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/providers/isar_provider.dart';
import '../models/focus_lock_session.dart';

/// Today's focus lock sessions (completed + voided).
final todayFocusLockSessionsProvider =
    FutureProvider<List<FocusLockSession>>((ref) async {
  if (kIsWeb) return [];

  final isar = await ref.watch(isarProvider.future);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));

  return isar
      .collection<FocusLockSession>()
      .filter()
      .startedAtBetween(start, end)
      .findAll();
});

/// All focus lock sessions, sorted newest first.
final allFocusLockSessionsProvider =
    FutureProvider<List<FocusLockSession>>((ref) async {
  if (kIsWeb) return [];

  final isar = await ref.watch(isarProvider.future);
  return isar
      .collection<FocusLockSession>()
      .where()
      .sortByStartedAtDesc()
      .findAll();
});

Future<void> saveFocusLockSessionToPrefs(FocusLockSession session) async {
  // No-op on native platforms where Isar is used directly
}
