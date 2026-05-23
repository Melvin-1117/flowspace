class UserProfile {
  int id = 0;

  // GitHub identity
  late String githubUsername;
  late String displayName;
  late String avatarUrl;
  late String bio;
  late String githubUrl;

  // GitHub stats (cached)
  late int publicRepos;
  late int followers;
  late int following;

  // App metadata
  late DateTime connectedAt;
  late DateTime lastSyncedAt;
  late bool isConnected;
}
