import 'package:isar/isar.dart';

part 'user_profile_isar.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

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
