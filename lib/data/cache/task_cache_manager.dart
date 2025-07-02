import 'package:hive_flutter/hive_flutter.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/services/notification_service.dart';

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

  static Future<void> deleteTaskAt(int index) async {
    var box = Hive.box<Task>(boxName);
    final task = box.getAt(index);
    if (task != null) {
      await NotificationService().cancelNotification(task.id);
    }
    await box.deleteAt(index);
  }

  static Future<void> updateTask(int index, Task updatedTask) async {
    var box = Hive.box<Task>(boxName);
    // final oldTask = box.getAt(index);
    await box.putAt(index, updatedTask);
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
      // print('Task with ID $taskId is already completed.');
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
    // print('Task with ID $taskId marked as completed.');
  }
}
