import 'package:flutter/services.dart';
import 'package:turnotask/modules/home/model/task_model.dart';

class NotificationHelper {
  static const MethodChannel _channel = MethodChannel('local_notifications');

  static Future<bool> hasNotificationPermission() async {
    return await _channel.invokeMethod('hasNotificationPermission') ?? false;
  }

  static Future<void> requestNotificationPermission() async {
    await _channel.invokeMethod('requestNotificationPermission');
  }

  static Future<void> requestNotificationPermissionAtStartup() async {
    final hasPermission = await hasNotificationPermission();
    if (!hasPermission) {
      print("no permission");
      await requestNotificationPermission();
    }
  }

  static Future<bool> hasExactAlarmPermission() async {
    return await _channel.invokeMethod<bool>('hasExactAlarmPermission') ??
        false;
  }

  static Future<void> requestExactAlarmPermission() async {
    await _channel.invokeMethod('requestExactAlarmPermission');
  }

  static Future<void> checkAndRequestExactAlarmPermission() async {
    final bool hasPermission = await hasExactAlarmPermission();
    if (hasPermission) {
      print('Exact alarms already permitted.');
    } else {
      print('Exact alarms NOT permitted. Opening settings...');
      await requestExactAlarmPermission();
    }
  }

  static Future<void> scheduleNotification({required Task task}) async {
    await _channel.invokeMethod('scheduleNotification', {
      'id': task.id,
      'title': task.title,
      'body': task.description,
      'timestamp': task.dateTime?.millisecondsSinceEpoch,
      'repeatInterval': task.recurrence.name ?? 'once',
    });
  }

  static Future<void> scheduleNotificationIos({required Task task}) async {
    await _channel.invokeMethod('scheduleNotification', {
      'id': task.id.toString(),
      'title': task.title,
      'body': task.description,
      'timestamp': task.dateTime?.millisecondsSinceEpoch.toDouble(),
      'repeatInterval': task.recurrence.name ?? 'once',
    });
  }

  static Future<void> cancelScheduledNotification(int id) async {
    await _channel.invokeMethod('cancelScheduledNotification', {'id': id});
  }

  static Future<void> cancelScheduledNotificationIos(String id) async {
    await _channel.invokeMethod('cancelNotification', id);
  }

  static Future<void> openAppSettings() async {
    try {
      await _channel.invokeMethod('openAppSettings');
    } catch (e) {
      print('Failed to open settings: $e');
    }
  }

  static Future<void> openAppNotificationSettings() async {
    await _channel.invokeMethod('openAppNotificationSettings');
  }
}
