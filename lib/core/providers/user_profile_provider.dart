import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../providers/isar_provider.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    if (kIsWeb) return null;
    return _loadFromIsar();
  }

  Future<UserProfile?> _loadFromIsar() async {
    final isar = await ref.read(isarProvider.future);
    return await isar.collection<UserProfile>().get(1);
  }

  /// Load cached profile on app start.
  Future<void> loadFromCache() async {
    state = const AsyncLoading();
    if (kIsWeb) {
      state = const AsyncData(null);
      return;
    }
    state = AsyncData(await _loadFromIsar());
  }

  /// Save profile to Isar.
  Future<void> saveProfile(UserProfile profile) async {
    if (kIsWeb) {
      state = AsyncData(profile);
      return;
    }
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() => isar.collection<UserProfile>().put(profile));
    state = AsyncData(profile);
  }

  /// Update profile fields locally.
  Future<void> updateProfile({
    String? displayName,
    String? avatarEmoji,
    String? bio,
    String? semesterName,
    String? courseName,
    DateTime? semesterEndDate,
    List<String>? primaryLanguages,
    int? dailySessionGoal,
    int? dailyCodingHoursGoal,
  }) async {
    final current = state.value;
    if (current == null) return;
    if (displayName != null) current.displayName = displayName;
    if (avatarEmoji != null) current.avatarEmoji = avatarEmoji;
    if (bio != null) current.bio = bio;
    if (semesterName != null) current.semesterName = semesterName;
    if (courseName != null) current.courseName = courseName;
    if (semesterEndDate != null) current.semesterEndDate = semesterEndDate;
    if (primaryLanguages != null) current.primaryLanguages = primaryLanguages;
    if (dailySessionGoal != null) current.dailySessionGoal = dailySessionGoal;
    if (dailyCodingHoursGoal != null) {
      current.dailyCodingHoursGoal = dailyCodingHoursGoal;
    }
    current.lastUpdatedAt = DateTime.now();
    await saveProfile(current);
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

// Quick access selectors
final avatarEmojiProvider = Provider<String>((ref) {
  return ref.watch(userProfileProvider).value?.avatarEmoji ?? '👨‍💻';
});

final avatarUrlProvider = Provider<String?>((ref) {
  return ref.watch(userProfileProvider).value?.avatarUrl;
});

final displayNameProvider = Provider<String>((ref) {
  final profile = ref.watch(userProfileProvider).value;
  return profile?.displayName ?? 'Developer';
});
