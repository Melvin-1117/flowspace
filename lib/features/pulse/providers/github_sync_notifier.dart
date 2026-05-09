import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/github_service.dart';
import 'pulse_providers.dart';

final githubSyncNotifierProvider =
    AsyncNotifierProvider<GitHubSyncNotifier, void>(GitHubSyncNotifier.new);

class GitHubSyncNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Executes full pulse sync and refreshes all dependent providers.
  Future<void> syncAll({bool silent = false}) async {
    state = const AsyncLoading();
    ref.read(syncLoadingProvider.notifier).state = true;
    try {
      final range = ref.read(dateRangeProvider);
      final bundle = await ref
          .read(githubServiceProvider)
          .syncAll(range: range);
      await persistSyncBundle(bundle: bundle, range: range);
      ref.invalidate(lastSyncedAtProvider);
      ref.invalidate(githubUserProvider);
      ref.invalidate(contributionDataProvider);
      ref.invalidate(languageDistributionProvider);
      ref.invalidate(recentEventsProvider);
      ref.invalidate(topRepositoriesProvider);
      ref.invalidate(allRepositoriesProvider);
      ref.read(offlineModeProvider.notifier).state = false;
      state = const AsyncData(null);
    } on GitHubApiException catch (e, st) {
      if (e.type == GitHubErrorType.network) {
        ref.read(offlineModeProvider.notifier).state = true;
        await markOfflineMode(true);
      } else if (e.type == GitHubErrorType.unauthorized) {
        await ref.read(githubServiceProvider).clearToken();
        await clearPulseCaches();
        await setTokenChangedFlag();
        ref.invalidate(githubTokenProvider);
        ref.invalidate(githubConnectedProvider);
      }
      state = AsyncError(e, st);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      ref.read(syncLoadingProvider.notifier).state = false;
      if (!silent) {
        ref.invalidateSelf();
      }
    }
  }
}
