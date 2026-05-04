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
}
