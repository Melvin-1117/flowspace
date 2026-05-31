import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';

import '../models/user_profile.dart';
import '../providers/isar_provider.dart';
import '../../features/pulse/providers/pulse_providers.dart';

class OnboardingService {
  final FlutterSecureStorage _storage;
  final Isar? _isar;

  static const _tokenKey = 'github_pat';
  static const _onboardingKey = 'onboarding_complete';

  OnboardingService(this._storage, this._isar);

  // Check if user has completed onboarding
  Future<bool> isOnboardingComplete() async {
    final value = await _storage.read(key: _onboardingKey);
    if (kIsWeb) {
      return value == 'true';
    }
    final isar = _isar;
    if (isar == null) return value == 'true';
    final profile = await isar.collection<UserProfile>().where().findFirst();
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
    if (kIsWeb) return;
    final isar = _isar;
    if (isar == null) return;
    await isar.writeTxn(() async {
      await isar.collection<UserProfile>().clear();
    });
  }
}

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService(
    const FlutterSecureStorage(),
    kIsWeb ? null : ref.watch(isarProvider).requireValue,
  );
});
