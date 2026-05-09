class RepositoryCache {
  RepositoryCache({
    required this.fullName,
    required this.name,
    required this.description,
    required this.htmlUrl,
    required this.defaultBranch,
    required this.stargazersCount,
    required this.forksCount,
    required this.watchersCount,
    required this.openIssuesCount,
    required this.primaryLanguage,
    required this.pushedAt,
    required this.topics,
    required this.cachedAt,
  });

  final String fullName;
  final String name;
  final String description;
  final String htmlUrl;
  final String defaultBranch;
  final int stargazersCount;
  final int forksCount;
  final int watchersCount;
  final int openIssuesCount;
  final String primaryLanguage;
  final DateTime pushedAt;
  final List<String> topics;
  final DateTime cachedAt;

  factory RepositoryCache.fromJson(Map<String, dynamic> json) {
    return RepositoryCache(
      fullName: json['fullName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      htmlUrl: json['htmlUrl'] as String? ?? '',
      defaultBranch: json['defaultBranch'] as String? ?? 'main',
      stargazersCount: json['stargazersCount'] as int? ?? 0,
      forksCount: json['forksCount'] as int? ?? 0,
      watchersCount: json['watchersCount'] as int? ?? 0,
      openIssuesCount: json['openIssuesCount'] as int? ?? 0,
      primaryLanguage: json['primaryLanguage'] as String? ?? 'Other',
      pushedAt:
          DateTime.tryParse(json['pushedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      topics: (json['topics'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      cachedAt:
          DateTime.tryParse(json['cachedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'name': name,
    'description': description,
    'htmlUrl': htmlUrl,
    'defaultBranch': defaultBranch,
    'stargazersCount': stargazersCount,
    'forksCount': forksCount,
    'watchersCount': watchersCount,
    'openIssuesCount': openIssuesCount,
    'primaryLanguage': primaryLanguage,
    'pushedAt': pushedAt.toIso8601String(),
    'topics': topics,
    'cachedAt': cachedAt.toIso8601String(),
  };
}
