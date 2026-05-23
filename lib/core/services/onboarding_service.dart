import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';

import '../models/user_profile.dart';
import '../providers/isar_provider.dart';
import '../../features/pulse/providers/pulse_providers.dart';

class OnboardingService {
  final FlutterSecureStorage _storage;
  final Isar _isar;

  static const _tokenKey = 'github_pat';
  static const _onboardingKey = 'onboarding_complete';

  OnboardingService(this._storage, this._isar);

  // Check if user has completed onboarding
  Future<bool> isOnboardingComplete() async {
    final value = await _storage.read(key: _onboardingKey);
    final profile = await _isar.userProfiles.where().findFirst();
    // Both must exist
    return value == 'true' && profile != null;
  }

  // Save GitHub token securely
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Read stored token
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  // Mark onboarding as done
  Future<void> markOnboardingComplete() async {
    await _storage.write(key: _onboardingKey, value: 'true');
  }

  // Clear all onboarding data
  // Used when token is revoked or expires
  Future<void> clearOnboarding() async {
    await _storage.deleteAll();
    await clearPulseCaches();
    await _isar.writeTxn(() async {
      await _isar.userProfiles.clear();
    });
  }
}

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService(
    const FlutterSecureStorage(),
    ref.watch(isarProvider).requireValue,
  );
});
