class GitHubEventCache {
  GitHubEventCache({
    required this.eventId,
    required this.eventType,
    required this.repoFullName,
    required this.description,
    required this.htmlUrl,
    required this.createdAt,
    required this.cachedAt,
    this.branch,
    this.shortSha,
    this.fullMessage,
  });

  final String eventId;
  final String eventType;
  final String repoFullName;
  final String description;
  final String htmlUrl;
  final String? branch;
  final String? shortSha;
  final String? fullMessage;
  final DateTime createdAt;
  final DateTime cachedAt;

  factory GitHubEventCache.fromJson(Map<String, dynamic> json) {
    return GitHubEventCache(
      eventId: json['eventId'] as String? ?? '',
      eventType: json['eventType'] as String? ?? 'EVENT',
      repoFullName: json['repoFullName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      htmlUrl: json['htmlUrl'] as String? ?? '',
      branch: json['branch'] as String?,
      shortSha: json['shortSha'] as String?,
      fullMessage: json['fullMessage'] as String?,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      cachedAt:
          DateTime.tryParse(json['cachedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
    'eventId': eventId,
    'eventType': eventType,
    'repoFullName': repoFullName,
    'description': description,
    'htmlUrl': htmlUrl,
    'branch': branch,
    'shortSha': shortSha,
    'fullMessage': fullMessage,
    'createdAt': createdAt.toIso8601String(),
    'cachedAt': cachedAt.toIso8601String(),
  };
}
