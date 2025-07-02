part of 'home_cubit.dart';

@CopyWith()
class HomeState extends Equatable {
  final bool isLoading;
  final String? error;
  final DateTime? selectedDateTime;
  final Recurrence selectedRecurrence;
  final List<Task> allTask;
  final bool hasNotificationPermission;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.selectedDateTime,
    this.selectedRecurrence = Recurrence.once,
    this.allTask = const [],
    this.hasNotificationPermission = false,
  });

  @override
  List<Object?> get props => [
    isLoading,
    error,
    selectedDateTime,
    selectedRecurrence,
    allTask,
    hasNotificationPermission,
  ];
}
