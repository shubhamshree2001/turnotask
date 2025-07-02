import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:turnotask/modules/home/model/task_model.dart';

@pragma('vm:entry-point')
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
            print("notiication clicked");
            print(notificationResponse.payload);
          },
      onDidReceiveBackgroundNotificationResponse: onNotificationResponse,
    );
  }

  Future<void> showInstantNotification({required Task task}) async {
    await flutterLocalNotificationsPlugin.show(
      task.id,
      task.title,
      task.description,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          channelDescription: 'TurnoTask reminders',
          importance: Importance.max,
          priority: Priority.high,
          actions: [AndroidNotificationAction('mark_done', 'Mark as Done')],
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> scheduleNotification(Task task) async {
    DateTimeComponents? matchComponents;

    switch (task.recurrence) {
      case Recurrence.daily:
        matchComponents = DateTimeComponents.time;
        break;
      case Recurrence.weekly:
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
        break;
      case Recurrence.monthly:
        matchComponents = DateTimeComponents.dayOfMonthAndTime;
        break;
      case Recurrence.once:
        matchComponents = null;
        break;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id,
      task.title,
      task.description,
      tz.TZDateTime.from(task.dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          channelDescription: 'TurnoTask reminders',
          importance: Importance.high,
          priority: Priority.high,
          actions: [AndroidNotificationAction('mark_done', 'Mark as Done')],
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: matchComponents,
      payload: task.id.toString(),
    );
  }

  @pragma('vm:entry-point')
  static void onNotificationResponse(NotificationResponse response) {
    debugPrint('Notification action tapped: ${response.actionId}');
    debugPrint('Notification payload: ${response.payload}');
    debugPrint('Notification payload: ${response.actionId}');

    // if (response.actionId == 'mark_done') {
    //   final payload = response.payload;
    //   if (payload != null) {
    //     final taskId = int.tryParse(payload);
    //     if (taskId != null) {
    //       NotificationService.markTaskAsDoneFromNotification(taskId);
    //     }
    //   }
    // }
  }

  void Function(int taskId)? _markDoneCallback;

  void registerMarkDoneCallback(void Function(int taskId) callback) {
    _markDoneCallback = callback;
  }

  static void markTaskAsDoneFromNotification(int taskId) {
    NotificationService()._markDoneCallback?.call(taskId);
  }

  Future<void> cancelNotification(int taskId) async {
    await flutterLocalNotificationsPlugin.cancel(taskId);
  }
}
