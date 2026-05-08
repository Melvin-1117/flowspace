import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static bool _timezoneInitialized = false;

  static Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    if (!_timezoneInitialized) {
      tz_data.initializeTimeZones();
      _timezoneInitialized = true;
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> showSessionComplete(String body) async {
    if (kIsWeb) return;
    await initialize();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'flowspace_pomodoro',
        'Pomodoro',
        channelDescription: 'Pomodoro completion alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(1001, 'FlowSpace', body, details);
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
    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledAt, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
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
    await _plugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledAt, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  static Future<void> cancel(int id) async {
    if (kIsWeb) return;
    await initialize();
    await _plugin.cancel(id);
  }
}
