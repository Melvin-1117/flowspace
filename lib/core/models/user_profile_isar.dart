import 'package:isar/isar.dart';

part 'user_profile_isar.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  // Identity
  late String displayName;
  late String avatarEmoji; // selected avatar emoji
  String avatarUrl = ''; // kept for backwards compat
  String bio = ''; // optional short bio

  // Academic info
  String semesterName = ''; // "Semester 7"
  String courseName = ''; // "B.Tech CSE"
  DateTime? semesterEndDate;

  // Developer preferences
  List<String> primaryLanguages = []; // ['Dart', 'Python']

  // Goals
  int dailySessionGoal = 4; // sessions per day
  int dailyCodingHoursGoal = 3; // hours per day

  // App metadata
  late DateTime createdAt;
  late DateTime lastUpdatedAt;
}
