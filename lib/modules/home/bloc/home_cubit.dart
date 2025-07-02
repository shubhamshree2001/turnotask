import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turnotask/data/cache/task_cache_manager.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/services/notification_service.dart';

part 'home_cubit.g.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void setSelectedDateTimeForTask(DateTime? selectedDateTime) {
    emit(state.copyWith(selectedDateTime: selectedDateTime));
  }

  void setSelectedRecurrenceForTask(Recurrence selectedRecurrence) {
    emit(state.copyWith(selectedRecurrence: selectedRecurrence));
  }

  void clearAllFields() {
    titleController.clear();
    descriptionController.clear();
    setSelectedDateTimeForTask(null);
    setSelectedRecurrenceForTask(Recurrence.once);
  }

  Future<void> loadAndCacheTask() async {
    final cachedTask = TaskCacheManager.loadTask();
    if (cachedTask.isNotEmpty) {
      emit(state.copyWith(allTask: cachedTask));
    } else {
      emit(state.copyWith(allTask: const []));
    }
  }

  Future<void> addTask(BuildContext context) async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        state.selectedDateTime == null) {
      return;
    }
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: titleController.text,
      description: descriptionController.text,
      dateTime: state.selectedDateTime!,
      recurrence: state.selectedRecurrence,
    );
    await NotificationService().scheduleNotification(newTask);
    await TaskCacheManager.saveTask(newTask);
    HapticFeedback.mediumImpact();
    await loadAndCacheTask();
    clearAllFields();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> deleteTask(int index) async {
    await TaskCacheManager.deleteTaskAt(index);
    await loadAndCacheTask();
    HapticFeedback.heavyImpact();
  }

  Future<void> markAsCompleted(Task task, int index) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dateTime: task.dateTime,
      isCompleted: true,
      completionTime: DateTime.now(),
      recurrence: task.recurrence,
    );
    await TaskCacheManager.updateTask(index, updatedTask);
    await loadAndCacheTask();
    HapticFeedback.mediumImpact();
  }
}
