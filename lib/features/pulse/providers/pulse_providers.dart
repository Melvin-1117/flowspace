import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/contribution_cache.dart';
import '../../../core/models/github_event_cache.dart';
import '../../../core/models/github_user_cache.dart';
import '../../../core/models/language_cache.dart';
import '../../../core/models/repository_cache.dart';
import '../pulse_types.dart';
import '../services/github_service.dart';

const _userCacheKey = 'pulse_user_cache';
const _contributionPrefix = 'pulse_contrib_';
const _languageCacheKey = 'pulse_languages';
const _eventsCacheKey = 'pulse_events';
const _reposCacheKey = 'pulse_repos';
const _lastSyncedAtKey = 'pulse_last_synced_at';
const _offlineBannerKey = 'pulse_offline_banner';
const _tokenChangedFlag = 'pulse_token_changed';

const _userTtl = Duration(hours: 24);
const _contributionsTtl = Duration(hours: 1);
const _languagesTtl = Duration(hours: 1);
const _reposTtl = Duration(hours: 1);
const _eventsTtl = Duration(minutes: 15);

/// Singleton GitHub service provider for all Pulse API and token operations.
final githubServiceProvider = Provider<GitHubService>((ref) => GitHubService());

/// Returns currently stored GitHub token (if any).
final githubTokenProvider = FutureProvider<String?>((ref) async {
  return ref.read(githubServiceProvider).getToken();
});

/// Whether a token exists and dashboard should show connected state.
final githubConnectedProvider = FutureProvider<bool>((ref) async {
  final token = await ref.watch(githubTokenProvider.future);
  return token != null && token.isNotEmpty;
});

/// Active contribution/event date range used by Pulse widgets.
final dateRangeProvider = StateProvider<DateRange>(
  (ref) => DateRange.last30Days,
);

/// Loading state for Sync button and auto-sync operations.
final syncLoadingProvider = StateProvider<bool>((ref) => false);

/// Whether network fallback mode is active and cached data is being shown.
final offlineModeProvider = StateProvider<bool>((ref) => false);

/// Exposes timestamp of last successful sync for subtitle display.
final lastSyncedAtProvider = FutureProvider<DateTime?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_lastSyncedAtKey);
  if (raw == null) return null;
  return DateTime.tryParse(raw);
});

/// Provider for cached-or-fresh authenticated GitHub user profile.
final githubUserProvider = FutureProvider<GitHubUserCache?>((ref) async {
  final connected = await ref.watch(githubConnectedProvider.future);
  if (!connected) return null;
  return _withCache<GitHubUserCache>(
    ref: ref,
    cacheKey: _userCacheKey,
    ttl: _userTtl,
    fromJson: GitHubUserCache.fromJson,
    fetchFresh: () async => ref.read(githubServiceProvider).fetchUser(),
  );
});

/// Provider for contribution calendar data with date-range-specific cache.
final contributionDataProvider = FutureProvider<ContributionData>((ref) async {
  final connected = await ref.watch(githubConnectedProvider.future);
  if (!connected)
    return ContributionData(totalContributions: 0, weeks: const []);
  final range = ref.watch(dateRangeProvider);
  return _withCache<ContributionCache>(
    ref: ref,
    cacheKey: '$_contributionPrefix${range.name}',
    ttl: _contributionsTtl,
    fromJson: ContributionCache.fromJson,
    fetchFresh: () async {
      final user = await ref.read(githubUserProvider.future);
      if (user == null || user.username.isEmpty) {
        return ContributionCache.fromData(
          data: ContributionData(totalContributions: 0, weeks: const []),
          range: range.name,
          cachedAt: DateTime.now(),
        );
      }
      final data = await ref
          .read(githubServiceProvider)
          .fetchContributions(username: user.username, range: range);
      return ContributionCache.fromData(
        data: data,
        range: range.name,
        cachedAt: DateTime.now(),
      );
    },
  ).then((cache) => cache.toContributionData());
});

/// Provider for language percentages and language-to-repository counts.
final languageDistributionProvider = FutureProvider<LanguageCache>((ref) async {
  final connected = await ref.watch(githubConnectedProvider.future);
  if (!connected) {
    return LanguageCache(
      languages: const {},
      repoCounts: const {},
      cachedAt: DateTime.now(),
    );
  }
  return _withCache<LanguageCache>(
    ref: ref,
    cacheKey: _languageCacheKey,
    ttl: _languagesTtl,
    fromJson: LanguageCache.fromJson,
    fetchFresh: () =>
        ref.read(githubServiceProvider).fetchLanguageDistribution(),
  );
});

/// Provider for recent terminal stream events with 15-minute TTL and dedupe.
final recentEventsProvider = FutureProvider<List<GitHubEventCache>>((
  ref,
) async {
  final connected = await ref.watch(githubConnectedProvider.future);
  if (!connected) return const [];
  final range = ref.watch(dateRangeProvider);
  final events = await _withCache<List<GitHubEventCache>>(
    ref: ref,
    cacheKey: _eventsCacheKey,
    ttl: _eventsTtl,
    fromJson: (json) => ((json['events'] as List<dynamic>? ?? const [])
        .map(
          (entry) => GitHubEventCache.fromJson(entry as Map<String, dynamic>),
        )
        .toList()),
    toJson: (value) => {
      'events': value.map((event) => event.toJson()).toList(),
      'cachedAt': DateTime.now().toIso8601String(),
    },
    fetchFresh: () async {
      final user = await ref.read(githubUserProvider.future);
      if (user == null || user.username.isEmpty)
        return const <GitHubEventCache>[];
      return ref
          .read(githubServiceProvider)
          .fetchRecentEvents(username: user.username, range: range);
    },
  );
  final deduped = <String, GitHubEventCache>{
    for (final e in events) e.eventId: e,
  }.values.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return deduped.take(100).toList();
});

/// Provider for top repositories shown on dashboard cards.
final topRepositoriesProvider = FutureProvider<List<RepositoryCache>>((
  ref,
) async {
  final repos = await ref.watch(allRepositoriesProvider.future);
  if (repos.isEmpty) return const [];
  final sorted = [...repos]
    ..sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
  return sorted.take(3).toList();
});

/// Provider for all repositories used by "View all" and quick actions.
final allRepositoriesProvider = FutureProvider<List<RepositoryCache>>((
  ref,
) async {
  final connected = await ref.watch(githubConnectedProvider.future);
  if (!connected) return const [];
  return _withCache<List<RepositoryCache>>(
    ref: ref,
    cacheKey: _reposCacheKey,
    ttl: _reposTtl,
    fromJson: (json) => ((json['repos'] as List<dynamic>? ?? const [])
        .map((entry) => RepositoryCache.fromJson(entry as Map<String, dynamic>))
        .toList()),
    toJson: (value) => {
      'repos': value.map((repo) => repo.toJson()).toList(),
      'cachedAt': DateTime.now().toIso8601String(),
    },
    fetchFresh: () => ref.read(githubServiceProvider).fetchAllRepos(),
  );
});

Future<void> persistSyncBundle({
  required GitHubSyncBundle bundle,
  required DateRange range,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userCacheKey, jsonEncode(bundle.user.toJson()));
  await prefs.setString(
    '$_contributionPrefix${range.name}',
    jsonEncode(
      ContributionCache.fromData(
        data: bundle.contributions,
        range: range.name,
        cachedAt: bundle.syncedAt,
      ).toJson(),
    ),
  );
  await prefs.setString(
    _languageCacheKey,
    jsonEncode(bundle.languageCache.toJson()),
  );
  await prefs.setString(
    _eventsCacheKey,
    jsonEncode({
      'events': bundle.events.map((e) => e.toJson()).toList(),
      'cachedAt': bundle.syncedAt.toIso8601String(),
    }),
  );
  await prefs.setString(
    _reposCacheKey,
    jsonEncode({
      'repos': bundle.allRepositories.map((e) => e.toJson()).toList(),
      'cachedAt': bundle.syncedAt.toIso8601String(),
    }),
  );
  await prefs.setString(_lastSyncedAtKey, bundle.syncedAt.toIso8601String());
  await prefs.setBool(_offlineBannerKey, false);
}

Future<void> clearPulseCaches() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys().where(
    (key) =>
        key.startsWith(_contributionPrefix) ||
        key == _userCacheKey ||
        key == _languageCacheKey ||
        key == _eventsCacheKey ||
        key == _reposCacheKey ||
        key == _lastSyncedAtKey,
  );
  for (final key in keys) {
    await prefs.remove(key);
  }
}

Future<void> setTokenChangedFlag() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_tokenChangedFlag, true);
}

Future<bool> consumeTokenChangedFlag() async {
  final prefs = await SharedPreferences.getInstance();
  final changed = prefs.getBool(_tokenChangedFlag) ?? false;
  if (changed) await prefs.remove(_tokenChangedFlag);
  return changed;
}

Future<void> markOfflineMode(bool isOffline) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_offlineBannerKey, isOffline);
}

Future<bool> readOfflineMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_offlineBannerKey) ?? false;
}

Future<T> _withCache<T>({
  required Ref ref,
  required String cacheKey,
  required Duration ttl,
  required T Function(Map<String, dynamic>) fromJson,
  required Future<T> Function() fetchFresh,
  Map<String, dynamic> Function(T value)? toJson,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final cachedRaw = prefs.getString(cacheKey);
  T? cached;
  DateTime? cachedAt;
  if (cachedRaw != null) {
    final decoded = jsonDecode(cachedRaw) as Map<String, dynamic>;
    cached = fromJson(decoded);
    final rawTs = decoded['cachedAt'] as String?;
    cachedAt = rawTs == null ? null : DateTime.tryParse(rawTs);
  }
  if (cached != null && cachedAt != null) {
    final isFresh = DateTime.now().difference(cachedAt) < ttl;
    if (isFresh) return cached;
    unawaited(() async {
      try {
        final fresh = await fetchFresh();
        await prefs.setString(
          cacheKey,
          jsonEncode(
            toJson != null ? toJson(fresh) : (fresh as dynamic).toJson(),
          ),
        );
        await markOfflineMode(false);
        ref.invalidateSelf();
      } on GitHubApiException catch (e) {
        if (e.type == GitHubErrorType.network) {
          await markOfflineMode(true);
        } else if (e.type == GitHubErrorType.unauthorized) {
          await ref.read(githubServiceProvider).clearToken();
          await clearPulseCaches();
          await setTokenChangedFlag();
          ref.invalidate(githubTokenProvider);
          ref.invalidate(githubConnectedProvider);
        }
      }
    }());
    return cached;
  }
  T fresh;
  try {
    fresh = await fetchFresh();
  } on GitHubApiException catch (e) {
    if (e.type == GitHubErrorType.unauthorized) {
      await ref.read(githubServiceProvider).clearToken();
      await clearPulseCaches();
      await setTokenChangedFlag();
      ref.invalidate(githubTokenProvider);
      ref.invalidate(githubConnectedProvider);
    }
    rethrow;
  }
  await prefs.setString(
    cacheKey,
    jsonEncode(toJson != null ? toJson(fresh) : (fresh as dynamic).toJson()),
  );
  await markOfflineMode(false);
  return fresh;
}
