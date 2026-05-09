import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../core/models/contribution_cache.dart';
import '../../../core/models/github_event_cache.dart';
import '../../../core/models/github_user_cache.dart';
import '../../../core/models/language_cache.dart';
import '../../../core/models/repository_cache.dart';
import '../pulse_types.dart';

const githubApiBase = 'https://api.github.com';
const _githubGraphQl = 'https://api.github.com/graphql';

const contributionQuery = r'''
query($username: String!, $from: DateTime!, $to: DateTime!) {
  user(login: $username) {
    contributionsCollection(from: $from, to: $to) {
      contributionCalendar {
        totalContributions
        weeks {
          contributionDays {
            date
            contributionCount
          }
        }
      }
    }
  }
}
''';

final tokenStorage = FlutterSecureStorage();

class GitHubApiException implements Exception {
  GitHubApiException({
    required this.message,
    required this.type,
    this.retryAt,
    this.statusCode,
  });

  final String message;
  final GitHubErrorType type;
  final DateTime? retryAt;
  final int? statusCode;
}

enum GitHubErrorType {
  unauthorized,
  rateLimited,
  network,
  invalidResponse,
  unknown,
}

class GitHubSyncBundle {
  GitHubSyncBundle({
    required this.user,
    required this.contributions,
    required this.events,
    required this.languageCache,
    required this.topRepositories,
    required this.allRepositories,
    required this.syncedAt,
  });

  final GitHubUserCache user;
  final ContributionData contributions;
  final List<GitHubEventCache> events;
  final LanguageCache languageCache;
  final List<RepositoryCache> topRepositories;
  final List<RepositoryCache> allRepositories;
  final DateTime syncedAt;
}

class GitHubIssue {
  GitHubIssue({
    required this.title,
    required this.htmlUrl,
    required this.state,
    required this.number,
  });

  final String title;
  final String htmlUrl;
  final String state;
  final int number;
}

class GitHubService {
  GitHubService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Reads the stored GitHub token from secure storage.
  Future<String?> getToken() async => tokenStorage.read(key: 'github_pat');

  /// Persists a GitHub token securely.
  Future<void> saveToken(String token) async {
    await tokenStorage.write(key: 'github_pat', value: token);
  }

  /// Removes the stored GitHub token.
  Future<void> clearToken() async {
    await tokenStorage.delete(key: 'github_pat');
  }

  /// Builds authenticated headers for GitHub API calls.
  Future<Map<String, String>> authHeaders({String? overrideToken}) async {
    final token = overrideToken ?? await getToken();
    return {
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
      'Content-Type': 'application/json',
    };
  }

  /// Verifies whether a provided token can access GitHub `/user`.
  Future<bool> verifyToken(String token) async {
    try {
      await _requestJson(
        Uri.parse('$githubApiBase/user'),
        overrideToken: token,
      );
      return true;
    } on GitHubApiException {
      return false;
    }
  }

  /// Fetches the authenticated GitHub user profile.
  Future<GitHubUserCache> fetchUser() async {
    final data =
        await _requestJson(Uri.parse('$githubApiBase/user'))
            as Map<String, dynamic>;
    return GitHubUserCache(
      username: data['login'] as String? ?? '',
      displayName: (data['name'] as String?)?.trim().isNotEmpty == true
          ? data['name'] as String
          : (data['login'] as String? ?? ''),
      avatarUrl: data['avatar_url'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      followers: data['followers'] as int? ?? 0,
      following: data['following'] as int? ?? 0,
      publicRepos: data['public_repos'] as int? ?? 0,
      cachedAt: DateTime.now(),
    );
  }

  /// Fetches and parses contribution data from GitHub GraphQL.
  Future<ContributionData> fetchContributions({
    required String username,
    required DateRange range,
  }) async {
    final now = DateTime.now().toUtc();
    final from = now.subtract(Duration(days: range.days));
    final payload = {
      'query': contributionQuery,
      'variables': {
        'username': username,
        'from': from.toIso8601String(),
        'to': now.toIso8601String(),
      },
    };
    final response = await _postJson(Uri.parse(_githubGraphQl), payload);
    final root = response['data'] as Map<String, dynamic>?;
    if (root == null || response['errors'] != null) {
      throw GitHubApiException(
        message: 'GraphQL contribution fetch failed.',
        type: GitHubErrorType.invalidResponse,
      );
    }
    final calendar =
        (((root['user'] as Map<String, dynamic>?)?['contributionsCollection']
                as Map<String, dynamic>?)?['contributionCalendar']
            as Map<String, dynamic>?) ??
        const {};
    final total = calendar['totalContributions'] as int? ?? 0;
    final weeksRaw = calendar['weeks'] as List<dynamic>? ?? const [];
    final weeks = weeksRaw.map((week) {
      final days =
          (week as Map<String, dynamic>)['contributionDays']
              as List<dynamic>? ??
          const [];
      return days
          .map(
            (day) => ContributionDay(
              date: DateTime.parse(
                (day as Map<String, dynamic>)['date'] as String,
              ),
              contributionCount: day['contributionCount'] as int? ?? 0,
            ),
          )
          .toList();
    }).toList();
    return ContributionData(totalContributions: total, weeks: weeks);
  }

  /// Fetches recent user events and maps GitHub event payloads into UI-ready records.
  Future<List<GitHubEventCache>> fetchRecentEvents({
    required String username,
    required DateRange range,
  }) async {
    final response =
        await _requestJson(
              Uri.parse('$githubApiBase/users/$username/events?per_page=50'),
            )
            as List<dynamic>;
    final cutoff = DateTime.now().subtract(Duration(days: range.days));
    final now = DateTime.now();
    return response
        .map((entry) => _eventFromJson(entry as Map<String, dynamic>, now))
        .where((event) => event.createdAt.isAfter(cutoff))
        .toList();
  }

  /// Fetches user repositories sorted by stars (top three for dashboard).
  Future<List<RepositoryCache>> fetchTopRepos() async {
    final repos = await fetchAllRepos();
    final sorted = [...repos]
      ..sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
    return sorted.take(3).toList();
  }

  /// Fetches all repositories visible to the authenticated user.
  Future<List<RepositoryCache>> fetchAllRepos() async {
    final response =
        await _requestJson(
              Uri.parse('$githubApiBase/user/repos?sort=pushed&per_page=100'),
            )
            as List<dynamic>;
    final now = DateTime.now();
    return response
        .map((repo) => _repoFromJson(repo as Map<String, dynamic>, now))
        .toList();
  }

  /// Calculates language percentages by summing per-repository language byte totals.
  Future<LanguageCache> fetchLanguageDistribution({
    List<RepositoryCache>? repositories,
  }) async {
    final repos = repositories ?? await fetchAllRepos();
    final totals = <String, int>{};
    final repoCounts = <String, int>{};
    for (final repo in repos) {
      final data =
          await _requestJson(
                Uri.parse('$githubApiBase/repos/${repo.fullName}/languages'),
              )
              as Map<String, dynamic>;
      if (data.isEmpty) {
        continue;
      }
      for (final entry in data.entries) {
        final lang = entry.key;
        final bytes = (entry.value as num).toInt();
        totals[lang] = (totals[lang] ?? 0) + bytes;
      }
      final primary = data.entries.toList()
        ..sort((a, b) => (b.value as num).compareTo(a.value as num));
      repoCounts[primary.first.key] = (repoCounts[primary.first.key] ?? 0) + 1;
    }
    final grandTotal = totals.values.fold<int>(0, (a, b) => a + b);
    if (grandTotal == 0) {
      return LanguageCache(
        languages: const {},
        repoCounts: const {},
        cachedAt: DateTime.now(),
      );
    }
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topFive = sorted.take(5).toList();
    final otherTotal = sorted
        .skip(5)
        .fold<int>(0, (sum, entry) => sum + entry.value);
    final percents = <String, double>{
      for (final entry in topFive) entry.key: (entry.value / grandTotal) * 100,
      if (otherTotal > 0) 'Other': (otherTotal / grandTotal) * 100,
    };
    return LanguageCache(
      languages: percents,
      repoCounts: repoCounts,
      cachedAt: DateTime.now(),
    );
  }

  /// Fetches a GitHub issue by `owner/repo#number` reference.
  Future<GitHubIssue> fetchIssueByRef(String ref) async {
    final parsed = RegExp(r'^([^/]+)/([^#]+)#(\d+)$').firstMatch(ref.trim());
    if (parsed == null) {
      throw GitHubApiException(
        message: 'Issue reference must look like owner/repo#123.',
        type: GitHubErrorType.invalidResponse,
      );
    }
    final owner = parsed.group(1)!;
    final repo = parsed.group(2)!;
    final issueNumber = parsed.group(3)!;
    final data =
        await _requestJson(
              Uri.parse(
                '$githubApiBase/repos/$owner/$repo/issues/$issueNumber',
              ),
            )
            as Map<String, dynamic>;
    return GitHubIssue(
      title: data['title'] as String? ?? 'Untitled issue',
      htmlUrl: data['html_url'] as String? ?? '',
      state: data['state'] as String? ?? 'open',
      number: data['number'] as int? ?? int.parse(issueNumber),
    );
  }

  /// Performs a full pulse sync payload in parallel for all dashboard sections.
  Future<GitHubSyncBundle> syncAll({required DateRange range}) async {
    final user = await fetchUser();
    final reposFuture = fetchAllRepos();
    final contributionsFuture = fetchContributions(
      username: user.username,
      range: range,
    );
    final eventsFuture = fetchRecentEvents(
      username: user.username,
      range: range,
    );
    final repos = await reposFuture;
    final languageFuture = fetchLanguageDistribution(repositories: repos);
    final topReposFuture = Future.value(
      ([...repos]
            ..sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount)))
          .take(3)
          .toList(),
    );
    final results = await Future.wait([
      contributionsFuture,
      eventsFuture,
      languageFuture,
      topReposFuture,
    ]);
    return GitHubSyncBundle(
      user: user,
      contributions: results[0] as ContributionData,
      events: results[1] as List<GitHubEventCache>,
      languageCache: results[2] as LanguageCache,
      topRepositories: results[3] as List<RepositoryCache>,
      allRepositories: repos,
      syncedAt: DateTime.now(),
    );
  }

  RepositoryCache _repoFromJson(Map<String, dynamic> json, DateTime now) {
    return RepositoryCache(
      fullName: json['full_name'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: (json['description'] as String?) ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      defaultBranch: json['default_branch'] as String? ?? 'main',
      stargazersCount: json['stargazers_count'] as int? ?? 0,
      forksCount: json['forks_count'] as int? ?? 0,
      watchersCount: json['watchers_count'] as int? ?? 0,
      openIssuesCount: json['open_issues_count'] as int? ?? 0,
      primaryLanguage: (json['language'] as String?) ?? 'Other',
      pushedAt: DateTime.tryParse(json['pushed_at'] as String? ?? '') ?? now,
      topics: ((json['topics'] as List<dynamic>?) ?? const [])
          .map((e) => '$e')
          .toList(),
      cachedAt: now,
    );
  }

  GitHubEventCache _eventFromJson(Map<String, dynamic> json, DateTime now) {
    final payload = json['payload'] as Map<String, dynamic>? ?? const {};
    final repo =
        (json['repo'] as Map<String, dynamic>? ?? const {})['name']
            as String? ??
        '';
    final createdAt =
        DateTime.tryParse(json['created_at'] as String? ?? '') ?? now;
    String description =
        payload['action'] as String? ??
        mapEventType(json['type'] as String? ?? '');
    String? branch;
    String? shortSha;
    String? fullMessage;
    String htmlUrl = 'https://github.com/$repo';
    if (json['type'] == 'PushEvent') {
      final commits = payload['commits'] as List<dynamic>? ?? const [];
      final firstCommit = commits.isNotEmpty
          ? commits.first as Map<String, dynamic>
          : null;
      description = firstCommit?['message'] as String? ?? 'Pushed commits';
      fullMessage = description;
      branch = (payload['ref'] as String?)?.split('/').last;
      shortSha = (payload['head'] as String?)?.substring(0, 7);
      if (shortSha != null) {
        htmlUrl = 'https://github.com/$repo/commit/${payload['head']}';
      }
    } else if (json['type'] == 'PullRequestEvent') {
      final pr = payload['pull_request'] as Map<String, dynamic>? ?? const {};
      description =
          pr['title'] as String? ?? 'Pull request ${payload['action'] ?? ''}';
      htmlUrl = pr['html_url'] as String? ?? htmlUrl;
    } else if (json['type'] == 'IssuesEvent') {
      final issue = payload['issue'] as Map<String, dynamic>? ?? const {};
      description =
          issue['title'] as String? ?? 'Issue ${payload['action'] ?? ''}';
      htmlUrl = issue['html_url'] as String? ?? htmlUrl;
    } else if (json['type'] == 'ReleaseEvent') {
      final release = payload['release'] as Map<String, dynamic>? ?? const {};
      description =
          release['name'] as String? ??
          release['tag_name'] as String? ??
          'Release published';
      htmlUrl = release['html_url'] as String? ?? htmlUrl;
    } else if (json['type'] == 'ForkEvent') {
      final forkee = payload['forkee'] as Map<String, dynamic>? ?? const {};
      description = 'Forked to ${forkee['full_name'] ?? 'new repository'}';
      htmlUrl = forkee['html_url'] as String? ?? htmlUrl;
    } else if (json['type'] == 'WatchEvent') {
      description = 'Starred $repo';
    } else if (json['type'] == 'CreateEvent') {
      description = 'Created ${payload['ref_type'] ?? 'resource'}';
      branch = payload['ref'] as String?;
    }
    return GitHubEventCache(
      eventId: json['id'] as String? ?? '',
      eventType: mapEventType(json['type'] as String? ?? ''),
      repoFullName: repo,
      description: description,
      branch: branch,
      shortSha: shortSha,
      fullMessage: fullMessage,
      htmlUrl: htmlUrl,
      createdAt: createdAt.toLocal(),
      cachedAt: now,
    );
  }

  Future<dynamic> _requestJson(Uri uri, {String? overrideToken}) async {
    try {
      final response = await _client.get(
        uri,
        headers: await authHeaders(overrideToken: overrideToken),
      );
      _throwIfFailed(response);
      return jsonDecode(response.body);
    } on SocketException {
      throw GitHubApiException(
        message: 'Network unavailable.',
        type: GitHubErrorType.network,
      );
    } on TimeoutException {
      throw GitHubApiException(
        message: 'Request timeout.',
        type: GitHubErrorType.network,
      );
    }
  }

  Future<Map<String, dynamic>> _postJson(
    Uri uri,
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _client.post(
        uri,
        headers: await authHeaders(),
        body: jsonEncode(payload),
      );
      _throwIfFailed(response);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on SocketException {
      throw GitHubApiException(
        message: 'Network unavailable.',
        type: GitHubErrorType.network,
      );
    } on TimeoutException {
      throw GitHubApiException(
        message: 'Request timeout.',
        type: GitHubErrorType.network,
      );
    }
  }

  void _throwIfFailed(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    if (response.statusCode == 401) {
      throw GitHubApiException(
        message: 'Token expired — please reconnect GitHub.',
        type: GitHubErrorType.unauthorized,
        statusCode: 401,
      );
    }
    if (response.statusCode == 403 || response.statusCode == 429) {
      final resetRaw = response.headers['x-ratelimit-reset'];
      DateTime? retryAt;
      if (resetRaw != null) {
        final ts = int.tryParse(resetRaw);
        if (ts != null)
          retryAt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      }
      throw GitHubApiException(
        message: 'GitHub rate limit reached.',
        type: GitHubErrorType.rateLimited,
        retryAt: retryAt,
        statusCode: response.statusCode,
      );
    }
    throw GitHubApiException(
      message: 'GitHub request failed.',
      type: GitHubErrorType.unknown,
      statusCode: response.statusCode,
    );
  }
}

String mapEventType(String githubType) => switch (githubType) {
  'PushEvent' => 'PUSH',
  'PullRequestEvent' => 'MERGE',
  'ReleaseEvent' => 'RELEASE',
  'IssuesEvent' => 'ISSUE',
  'WatchEvent' => 'WATCH',
  'ForkEvent' => 'FORK',
  'CreateEvent' => 'CREATE',
  'DeleteEvent' => 'DELETE',
  'IssueCommentEvent' => 'COMMENT',
  _ => 'EVENT',
};
