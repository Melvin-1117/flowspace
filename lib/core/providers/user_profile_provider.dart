import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../providers/isar_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    if (kIsWeb) {
      return _loadFromPrefs();
    }
    return _loadFromIsar();
  }

  Future<UserProfile?> _loadFromIsar() async {
    final isar = await ref.read(isarProvider.future);
    return await isar.collection<UserProfile>().get(1);
  }

  Future<UserProfile> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_displayName') ?? 'Alex Developer';
    final avatar = prefs.getString('profile_avatarEmoji') ?? '👨‍💻';
    final bio = prefs.getString('profile_bio') ?? 'CS Student & Developer';
    final sem = prefs.getString('profile_semesterName') ?? 'Semester 5';
    final course = prefs.getString('profile_courseName') ?? 'B.Tech CSE';
    final langs =
        prefs.getStringList('profile_primaryLanguages') ??
        ['Dart', 'Python', 'JavaScript'];
    final sessionGoal = prefs.getInt('profile_dailySessionGoal') ?? 4;
    final hoursGoal = prefs.getInt('profile_dailyCodingHoursGoal') ?? 3;
    final createdStr = prefs.getString('profile_createdAt');
    final created = createdStr != null
        ? DateTime.parse(createdStr)
        : DateTime.now();

    return UserProfile()
      ..displayName = name
      ..avatarEmoji = avatar
      ..bio = bio
      ..semesterName = sem
      ..courseName = course
      ..primaryLanguages = langs
      ..dailySessionGoal = sessionGoal
      ..dailyCodingHoursGoal = hoursGoal
      ..createdAt = created
      ..lastUpdatedAt = DateTime.now();
  }

  Future<void> _saveToPrefs(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_displayName', profile.displayName);
    await prefs.setString('profile_avatarEmoji', profile.avatarEmoji);
    await prefs.setString('profile_bio', profile.bio);
    await prefs.setString('profile_semesterName', profile.semesterName);
    await prefs.setString('profile_courseName', profile.courseName);
    await prefs.setStringList(
      'profile_primaryLanguages',
      profile.primaryLanguages,
    );
    await prefs.setInt('profile_dailySessionGoal', profile.dailySessionGoal);
    await prefs.setInt(
      'profile_dailyCodingHoursGoal',
      profile.dailyCodingHoursGoal,
    );
    await prefs.setString(
      'profile_createdAt',
      profile.createdAt.toIso8601String(),
    );
  }

  /// Load cached profile on app start.
  Future<void> loadFromCache() async {
    state = const AsyncLoading();
    if (kIsWeb) {
      state = AsyncData(await _loadFromPrefs());
      return;
    }
    state = AsyncData(await _loadFromIsar());
  }

  /// Save profile to Isar or SharedPreferences.
  Future<void> saveProfile(UserProfile profile) async {
    if (kIsWeb) {
      await _saveToPrefs(profile);
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
