part of 'home_cubit.dart';

@CopyWith()
class HomeState extends Equatable {
  final bool isLoading;
  final String? error;
  final DateTime? selectedDateTime;
  final Recurrence selectedRecurrence;
  final List<Task> allTask;
  final bool hasExactAlarmNotificationPermission;
  final bool hasNotificationPermissionIos;
  final String? title;
  final String? desc;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.selectedDateTime,
    this.selectedRecurrence = Recurrence.none,
    this.allTask = const [],
    this.hasExactAlarmNotificationPermission = false,
    this.hasNotificationPermissionIos = false,
    this.title,
    this.desc,
  });

  @override
  List<Object?> get props => [
    isLoading,
    error,
    selectedDateTime,
    selectedRecurrence,
    allTask,
    hasExactAlarmNotificationPermission,
    hasNotificationPermissionIos,
    title,
    desc
  ];
}
