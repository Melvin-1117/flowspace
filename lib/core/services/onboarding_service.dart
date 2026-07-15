import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';
import '../providers/isar_provider.dart';
import '../../features/devtrack/models/coding_session.dart';
import '../../features/devtrack/models/dev_project.dart';
import '../../features/devtrack/models/skill_entry.dart';
import '../../features/devtrack/models/daily_dev_log.dart';

class OnboardingService {
  final Isar? _isar;

  static const _onboardingKey = 'onboarding_complete';

  OnboardingService(this._isar);

  /// Check if user has completed onboarding.
  /// UserProfile existence IS the completion flag on native.
  Future<bool> isOnboardingComplete() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    }
    final isar = _isar;
    if (isar == null) return false;
    final profile = await isar.collection<UserProfile>().where().findFirst();
    return profile != null;
  }

  /// Mark onboarding as done (web only; on native, saving UserProfile is enough).
  Future<void> markOnboardingComplete() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
    }
    // On native, UserProfile existence is the flag.
  }

  /// Clear all onboarding and DevTrack data.
  Future<void> clearOnboarding() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingKey);
      return;
    }
    final isar = _isar;
    if (isar == null) return;
    await isar.writeTxn(() async {
      await isar.collection<UserProfile>().clear();
      await isar.collection<DevProject>().clear();
      await isar.collection<CodingSession>().clear();
      await isar.collection<SkillEntry>().clear();
      await isar.collection<DailyDevLog>().clear();
    });
  }
}

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  // Use .valueOrNull so we don't throw if Isar hasn't resolved yet.
  // OnboardingService handles null isar by returning false (not complete).
  return OnboardingService(kIsWeb ? null : ref.watch(isarProvider).valueOrNull);
});
