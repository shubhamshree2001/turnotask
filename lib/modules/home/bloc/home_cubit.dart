import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turnotask/data/cache/task_cache_manager.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/services/get_it_service.dart';
import 'package:turnotask/services/notification_helper.dart';

part 'home_cubit.g.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> checkHasNotificationPermissionAndroid() async {
    bool hasPermission = await NotificationHelper.hasNotificationPermission();
    emit(state.copyWith(hasNotificationPermissionAndroid: hasPermission));
  }

  Future<void> checkHasNotificationPermissionIos() async {
    bool hasPermission = await NotificationHelper.hasNotificationPermission();
    emit(state.copyWith(hasNotificationPermissionIos: hasPermission));
  }

  Future<void> checkHasExactAlarmNotificationPermission() async {
    bool hasPermission = await NotificationHelper.hasExactAlarmPermission();
    emit(state.copyWith(hasExactAlarmNotificationPermission: hasPermission));
  }

  void updateTaskTitle(String? title) {
    emit(state.copyWith(title: title));
  }

  void updateTaskDescription(String? desc) {
    emit(state.copyWith(desc: desc));
  }

  void setSelectedDateTimeForTask(DateTime? dateTime) {
    emit(state.copyWith(selectedDateTime: dateTime));
    if (dateTime != null) {
      if (state.selectedRecurrence == Recurrence.none) {
        setSelectedRecurrenceForTask(Recurrence.once);
      }
    } else {
      setSelectedRecurrenceForTask(Recurrence.none);
    }
  }

  void setSelectedRecurrenceForTask(Recurrence selectedRecurrence) {
    emit(state.copyWith(selectedRecurrence: selectedRecurrence));
  }

  void clearAllFields() {
    titleController.clear();
    descriptionController.clear();
    setSelectedDateTimeForTask(null);
    setSelectedRecurrenceForTask(Recurrence.none);
    updateTaskTitle(null);
    updateTaskDescription(null);
  }

  Future<void> loadAndCacheTask() async {
    final cachedTask = TaskCacheManager.loadTask();
    final completedTasks = cachedTask
        .where((task) => task.isCompleted)
        .toList();
    final inProgressTasks = cachedTask
        .where((task) => !task.isCompleted)
        .toList();
    if (cachedTask.isNotEmpty) {
      emit(
        state.copyWith(
          allTask: cachedTask,
          completedTask: completedTasks,
          inProgressTask: inProgressTasks,
        ),
      );
    } else {
      emit(
        state.copyWith(
          allTask: const [],
          completedTask: const [],
          inProgressTask: const [],
        ),
      );
    }
  }

  Future<void> addTask(BuildContext context) async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      return;
    }

    final hasReminder = Platform.isAndroid
        ? state.hasExactAlarmNotificationPermission &&
              state.hasNotificationPermissionAndroid &&
              state.selectedDateTime != null
        : state.hasNotificationPermissionIos && state.selectedDateTime != null;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: titleController.text,
      description: descriptionController.text,
      dateTime: hasReminder ? state.selectedDateTime : null,
      recurrence: hasReminder ? state.selectedRecurrence : Recurrence.none,
    );

    if (hasReminder) {
      if (Platform.isAndroid) {
        await NotificationHelper.scheduleNotification(task: newTask);
      } else {
        await NotificationHelper.scheduleNotificationIos(task: newTask);
      }
    }

    await TaskCacheManager.saveTask(newTask);
    HapticFeedback.mediumImpact();
    await loadAndCacheTask();

    clearAllFields();

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> deleteTask(int taskId) async {
    await TaskCacheManager.deleteTask(taskId);
    await loadAndCacheTask();
    HapticFeedback.heavyImpact();
  }

  Future<void> markAsCompleted(Task task, int taskId) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dateTime: task.dateTime,
      isCompleted: true,
      completionTime: DateTime.now(),
      recurrence: task.recurrence,
    );
    await TaskCacheManager.updateTask(taskId, updatedTask);
    await loadAndCacheTask();
    HapticFeedback.mediumImpact();
  }

  Future<void> setDataToEditTask(int taskId) async {
    Task? task = await TaskCacheManager.findTask(taskId);
    if (task != null) {
      titleController.text = task.title;
      descriptionController.text = task.description;
      emit(
        state.copyWith(
          selectedDateTime: task.dateTime,
          selectedRecurrence: task.recurrence,
          title: task.title,
          desc: task.description,
        ),
      );
    }
  }

  Future<void> updateEditedTask(int taskId, BuildContext context) async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      return;
    }

    final hasReminder = Platform.isAndroid
        ? state.hasExactAlarmNotificationPermission &&
              state.hasNotificationPermissionAndroid &&
              state.selectedDateTime != null
        : state.hasNotificationPermissionIos && state.selectedDateTime != null;

    final updatedTask = Task(
      id: taskId,
      title: titleController.text,
      description: descriptionController.text,
      dateTime: hasReminder ? state.selectedDateTime : null,
      recurrence: hasReminder ? state.selectedRecurrence : Recurrence.none,
    );

    if (hasReminder) {
      if (Platform.isAndroid) {
        await NotificationHelper.scheduleNotification(task: updatedTask);
      } else {
        await NotificationHelper.scheduleNotificationIos(task: updatedTask);
      }
    }

    await TaskCacheManager.updateTask(taskId, updatedTask);
    HapticFeedback.mediumImpact();
    await loadAndCacheTask();

    clearAllFields();

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> updateTaskData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // int? taskId = await turnoStorage.getNotificationTaskId();
    final refreshedPrefs = await SharedPreferences.getInstance();
    int taskId = refreshedPrefs.getInt('flutter.notificationTaskID') ?? -1;
    print("task id : $taskId");
    if (taskId != null && taskId != -1) {
      await TaskCacheManager.markTaskAsCompletedById(taskId);
      // await turnoStorage.remove(TurnoStorageKeys.notificationTaskId);
      gPrefs.clear();
      await loadAndCacheTask();
    }
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final day = DateFormat('d').format(dateTime);
    final month = DateFormat('MMMM').format(dateTime);
    final time = DateFormat('h:mm a').format(dateTime);
    return '$day $month $time';
  }
}
