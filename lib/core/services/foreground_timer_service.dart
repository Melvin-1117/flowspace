import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

const pauseResumeActionId = 'pause_resume_action';
const stopActionId = 'stop_action';

@pragma('vm:entry-point')
void _serviceEntryPoint() {
  FlutterForegroundTask.setTaskHandler(TimerTaskHandler());
}

class TimerTaskHandler extends TaskHandler {
  bool _isRunning = true;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onReceiveData(Object data) async {
    if (data is Map && data['formattedTime'] is String) {
      _isRunning = data['isRunning'] == true;
      await FlutterForegroundTask.updateService(
        notificationText: '${data['formattedTime']} remaining',
      );
    }
  }

  @override
  Future<void> onNotificationButtonPressed(String id) async {
    switch (id) {
      case pauseResumeActionId:
        FlutterForegroundTask.sendDataToMain({'action': 'pause_resume'});
        _isRunning = !_isRunning;
        await FlutterForegroundTask.updateService(
          notificationButtons: [
            NotificationButton(
              id: pauseResumeActionId,
              text: _isRunning ? 'Pause' : 'Resume',
            ),
            const NotificationButton(id: stopActionId, text: 'Stop Session'),
          ],
        );
        break;
      case stopActionId:
        FlutterForegroundTask.sendDataToMain({'action': 'stop'});
        await FlutterForegroundTask.stopService();
        break;
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {}
}

class ForegroundTimerService {
  ForegroundTimerService._();

  static bool _initialized = false;
  static StreamSubscription<dynamic>? _mainActionSub;
  static Timer? _notificationUpdateTimer;

  static Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'flowspace_focus',
        channelName: 'FlowSpace Focus Timer',
        channelDescription: 'Keeps Pomodoro sessions running in background',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(60000),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
    _initialized = true;
  }

  static Future<void> start({
    required String title,
    required String text,
    required bool isRunning,
  }) async {
    if (kIsWeb) return;
    await initialize();
    final running = await FlutterForegroundTask.isRunningService;
    final buttons = _notificationButtons(isRunning);
    if (!running) {
      await FlutterForegroundTask.startService(
        serviceId: 101,
        notificationTitle: title,
        notificationText: text,
        notificationButtons: buttons,
        callback: _serviceEntryPoint,
      );
    } else {
      await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
        notificationButtons: buttons,
      );
    }
    _startSlowUpdateTicker();
  }

  static Future<void> update({
    required String title,
    required String text,
    required bool isRunning,
  }) async {
    if (kIsWeb) return;
    final running = await FlutterForegroundTask.isRunningService;
    if (running) {
      await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
        notificationButtons: _notificationButtons(isRunning),
      );
    }
  }

  static Future<void> pushTimerTick({
    required String formattedTime,
    required bool isRunning,
  }) async {
    if (kIsWeb) return;
    FlutterForegroundTask.sendDataToTask({
      'formattedTime': formattedTime,
      'isRunning': isRunning,
    });
  }

  static void registerActionListener(void Function(String action) onAction) {
    if (kIsWeb) return;
    _mainActionSub?.cancel();
    // ignore: invalid_use_of_visible_for_testing_member
    _mainActionSub = FlutterForegroundTask.receivePort?.listen((data) {
      if (data is Map && data['action'] is String) {
        onAction(data['action'] as String);
      }
    });
  }

  static void enableLowBatteryMode() {
    _notificationUpdateTimer?.cancel();
    _notificationUpdateTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) {},
    );
  }

  static Future<void> stop() async {
    if (kIsWeb) return;
    _notificationUpdateTimer?.cancel();
    final running = await FlutterForegroundTask.isRunningService;
    if (running) {
      await FlutterForegroundTask.stopService();
    }
  }

  static List<NotificationButton> _notificationButtons(bool isRunning) {
    return [
      NotificationButton(
        id: pauseResumeActionId,
        text: isRunning ? 'Pause' : 'Resume',
      ),
      const NotificationButton(id: stopActionId, text: 'Stop Session'),
    ];
  }

  static void _startSlowUpdateTicker() {
    _notificationUpdateTimer ??= Timer.periodic(
      const Duration(minutes: 1),
      (_) {},
    );
  }
}
