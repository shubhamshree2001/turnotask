import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/services/notification_helper.dart';

class TaskCacheManager {
  static const String boxName = 'tasksBox';

  static Future<void> saveTask(Task task) async {
    var box = Hive.box<Task>(boxName);
    await box.add(task);
  }

  static List<Task> loadTask() {
    var box = Hive.box<Task>(boxName);
    return box.values.toList();
  }

  static Future<Task?> findTask(int taskId) async {
    var box = Hive.box<Task>(boxName);

    final task = box.values.where((t) => t.id == taskId);

    if (task.isNotEmpty) {
      return task.first;
    } else {
      return null;
    }
  }

  static Future<void> deleteTask(int taskID) async {
    var box = Hive.box<Task>(boxName);
    final taskKey = box.keys.firstWhere(
      (key) => box.get(key)?.id == taskID,
      orElse: () => null,
    );
    if (taskKey != null) {
      final task = box.get(taskKey);
      if (task != null) {
        if (Platform.isAndroid) {
          await NotificationHelper.cancelScheduledNotification(task.id);
        } else {
          await NotificationHelper.cancelScheduledNotificationIos(
            task.id.toString(),
          );
        }
      }
      await box.delete(taskKey);
    }
  }

  static Future<void> updateTask(int taskId, Task updatedTask) async {
    var box = Hive.box<Task>(boxName);
    final taskKey = box.keys.firstWhere(
      (key) => box.get(key)?.id == taskId,
      orElse: () => null,
    );
    if (taskKey != null) {
      await box.put(taskKey, updatedTask);
    } else {
      throw Exception('Task with ID $taskId not found.');
    }
  }

  static Future<void> markTaskAsCompletedById(int taskId) async {
    final box = Hive.box<Task>(boxName);
    final entry = box.values.toList().asMap().entries.firstWhere(
      (e) => e.value.id == taskId,
      orElse: () => throw Exception('Task with ID $taskId not found.'),
    );
    final index = entry.key;
    final task = entry.value;
    if (task.isCompleted) {
      return;
    }
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dateTime: task.dateTime,
      isCompleted: true,
      completionTime: DateTime.now(),
      recurrence: task.recurrence,
    );
    await box.putAt(index, updatedTask);
    print('Task with ID $taskId marked as completed.');
  }

  static Future<void> handleBootReschedule() async {
    final tasks = TaskCacheManager.loadTask();
    final now = DateTime.now();

    for (var task in tasks) {
      final reminderDate = task.dateTime;

      if (reminderDate != null &&
          !task.isCompleted &&
          reminderDate.isAfter(now)) {
        await NotificationHelper.scheduleNotification(task: task);
      }
    }
  }
}
