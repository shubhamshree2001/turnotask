// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_cubit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HomeStateCWProxy {
  HomeState isLoading(bool isLoading);

  HomeState error(String? error);

  HomeState selectedDateTime(DateTime? selectedDateTime);

  HomeState selectedRecurrence(Recurrence selectedRecurrence);

  HomeState allTask(List<Task> allTask);

  HomeState hasExactAlarmNotificationPermission(
    bool hasExactAlarmNotificationPermission,
  );

  HomeState hasNotificationPermissionIos(bool hasNotificationPermissionIos);

  HomeState title(String? title);

  HomeState desc(String? desc);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeState(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeState call({
    bool isLoading,
    String? error,
    DateTime? selectedDateTime,
    Recurrence selectedRecurrence,
    List<Task> allTask,
    bool hasExactAlarmNotificationPermission,
    bool hasNotificationPermissionIos,
    String? title,
    String? desc,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHomeState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHomeState.copyWith.fieldName(...)`
class _$HomeStateCWProxyImpl implements _$HomeStateCWProxy {
  const _$HomeStateCWProxyImpl(this._value);

  final HomeState _value;

  @override
  HomeState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override
  HomeState error(String? error) => this(error: error);

  @override
  HomeState selectedDateTime(DateTime? selectedDateTime) =>
      this(selectedDateTime: selectedDateTime);

  @override
  HomeState selectedRecurrence(Recurrence selectedRecurrence) =>
      this(selectedRecurrence: selectedRecurrence);

  @override
  HomeState allTask(List<Task> allTask) => this(allTask: allTask);

  @override
  HomeState hasExactAlarmNotificationPermission(
    bool hasExactAlarmNotificationPermission,
  ) => this(
    hasExactAlarmNotificationPermission: hasExactAlarmNotificationPermission,
  );

  @override
  HomeState hasNotificationPermissionIos(bool hasNotificationPermissionIos) =>
      this(hasNotificationPermissionIos: hasNotificationPermissionIos);

  @override
  HomeState title(String? title) => this(title: title);

  @override
  HomeState desc(String? desc) => this(desc: desc);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeState(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeState call({
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
    Object? selectedDateTime = const $CopyWithPlaceholder(),
    Object? selectedRecurrence = const $CopyWithPlaceholder(),
    Object? allTask = const $CopyWithPlaceholder(),
    Object? hasExactAlarmNotificationPermission = const $CopyWithPlaceholder(),
    Object? hasNotificationPermissionIos = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? desc = const $CopyWithPlaceholder(),
  }) {
    return HomeState(
      isLoading: isLoading == const $CopyWithPlaceholder()
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as String?,
      selectedDateTime: selectedDateTime == const $CopyWithPlaceholder()
          ? _value.selectedDateTime
          // ignore: cast_nullable_to_non_nullable
          : selectedDateTime as DateTime?,
      selectedRecurrence: selectedRecurrence == const $CopyWithPlaceholder()
          ? _value.selectedRecurrence
          // ignore: cast_nullable_to_non_nullable
          : selectedRecurrence as Recurrence,
      allTask: allTask == const $CopyWithPlaceholder()
          ? _value.allTask
          // ignore: cast_nullable_to_non_nullable
          : allTask as List<Task>,
      hasExactAlarmNotificationPermission:
          hasExactAlarmNotificationPermission == const $CopyWithPlaceholder()
          ? _value.hasExactAlarmNotificationPermission
          // ignore: cast_nullable_to_non_nullable
          : hasExactAlarmNotificationPermission as bool,
      hasNotificationPermissionIos:
          hasNotificationPermissionIos == const $CopyWithPlaceholder()
          ? _value.hasNotificationPermissionIos
          // ignore: cast_nullable_to_non_nullable
          : hasNotificationPermissionIos as bool,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      desc: desc == const $CopyWithPlaceholder()
          ? _value.desc
          // ignore: cast_nullable_to_non_nullable
          : desc as String?,
    );
  }
}

extension $HomeStateCopyWith on HomeState {
  /// Returns a callable class that can be used as follows: `instanceOfHomeState.copyWith(...)` or like so:`instanceOfHomeState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HomeStateCWProxy get copyWith => _$HomeStateCWProxyImpl(this);
}
