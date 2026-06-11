class UserProfile {
  int id = 0;

  // Identity
  late String displayName;
  late String avatarEmoji;
  String avatarUrl = '';
  String bio = '';

  // Academic info
  String semesterName = '';
  String courseName = '';
  DateTime? semesterEndDate;

  // Developer preferences
  List<String> primaryLanguages = [];

  // Goals
  int dailySessionGoal = 4;
  int dailyCodingHoursGoal = 3;

  // App metadata
  late DateTime createdAt;
  late DateTime lastUpdatedAt;
}
