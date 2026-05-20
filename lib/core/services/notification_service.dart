import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> showSessionComplete(String body) async {
    if (kIsWeb) return;
    await initialize();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pomodoro_alarm',
        'Pomodoro Alarms',
        channelDescription: 'Pomodoro completion alerts',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        playSound: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList(
          [0, 500, 200, 500, 200, 500],
        ),
      ),
    );
    await _plugin.show(1001, '🎯  Focus Session Complete!', body, details);
  }

  static Future<void> scheduleFocusBlockReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  }) async {
    if (kIsWeb) return;
    await initialize();
    if (scheduledAt.isBefore(DateTime.now())) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'flowspace_planner_focus',
        'Planner Focus Blocks',
        channelDescription: 'Focus block reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    // await _plugin.schedule(
    //   notificationId,
    //   title,
    //   body,
    //   scheduledAt,
    //   details,
    //   payload: payload,
    // );
  }

  static Future<void> scheduleMilestoneReminder({
    required int notificationId,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  }) async {
    if (kIsWeb) return;
    await initialize();
    if (scheduledAt.isBefore(DateTime.now())) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'flowspace_planner_milestone',
        'Planner Milestones',
        channelDescription: 'Milestone reminders',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    // await _plugin.schedule(
    //   notificationId,
    //   title,
    //   body,
    //   scheduledAt,
    //   details,
    //   payload: payload,
    // );
  }

  static Future<void> cancel(int id) async {
    if (kIsWeb) return;
    await initialize();
    await _plugin.cancel(id);
  }
}
