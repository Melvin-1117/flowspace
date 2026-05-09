class GitHubUserCache {
  GitHubUserCache({
    required this.username,
    required this.displayName,
    required this.avatarUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.publicRepos,
    required this.cachedAt,
  });

  final String username;
  final String displayName;
  final String avatarUrl;
  final String bio;
  final int followers;
  final int following;
  final int publicRepos;
  final DateTime cachedAt;

  factory GitHubUserCache.fromJson(Map<String, dynamic> json) {
    return GitHubUserCache(
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      publicRepos: json['publicRepos'] as int? ?? 0,
      cachedAt:
          DateTime.tryParse(json['cachedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'bio': bio,
    'followers': followers,
    'following': following,
    'publicRepos': publicRepos,
    'cachedAt': cachedAt.toIso8601String(),
  };
}
