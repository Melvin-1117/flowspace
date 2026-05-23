import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../models/user_profile_isar.dart';
import '../providers/isar_provider.dart';
import '../services/onboarding_service.dart';
import '../../features/pulse/providers/pulse_providers.dart';

class UserProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    return _loadFromIsar();
  }

  Future<UserProfile?> _loadFromIsar() async {
    final isar = await ref.read(isarProvider.future);
    // Try to get the first profile by ID
    return await isar.userProfiles.get(1);
  }

  // Load cached profile on app start
  Future<void> loadFromCache() async {
    state = const AsyncLoading();
    state = AsyncData(await _loadFromIsar());
  }

  // Save new profile after GitHub connect
  Future<void> saveProfile(UserProfile profile) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() => isar.userProfiles.put(profile));
    state = AsyncData(profile);
  }

  // Refresh from GitHub API
  Future<void> refreshFromGitHub() async {
    final token = await ref.read(onboardingServiceProvider).getToken();
    if (token == null || token.isEmpty) {
      throw StateError('Missing GitHub token');
    }
    final fresh = await ref
        .read(githubServiceProvider)
        .verifyAndFetchProfile(token);
    await saveProfile(fresh);
  }

  // Update avatar URL only
  Future<void> updateAvatarUrl(String url) async {
    final current = state.value;
    if (current == null) return;
    current.avatarUrl = url;
    await saveProfile(current);
  }
}

final userProfileProvider =
    AsyncNotifierProvider<UserProfileNotifier, UserProfile?>(
      UserProfileNotifier.new,
    );

// Quick access selectors
final usernameProvider = Provider<String>((ref) {
  return ref.watch(userProfileProvider).value?.githubUsername ?? '';
});

final avatarUrlProvider = Provider<String?>((ref) {
  return ref.watch(userProfileProvider).value?.avatarUrl;
});

final displayNameProvider = Provider<String>((ref) {
  final profile = ref.watch(userProfileProvider).value;
  return profile?.displayName.isNotEmpty == true
      ? profile!.displayName
      : profile?.githubUsername ?? 'Developer';
});
