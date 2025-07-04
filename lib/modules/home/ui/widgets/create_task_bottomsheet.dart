import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/modules/home/bloc/home_cubit.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/modules/home/ui/widgets/notification_permission_dialogue.dart';
import 'package:turnotask/modules/home/ui/widgets/primary_cta.dart';
import 'package:turnotask/widgets/bottom_sheet_mainframe.dart';
import 'package:turnotask/widgets/kapp_widget.dart';

class CreateTaskBottomSheet extends StatefulWidget {
  const CreateTaskBottomSheet({super.key});

  @override
  State<CreateTaskBottomSheet> createState() => _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<CreateTaskBottomSheet> {
  String getSheetTitle() {
    return "Create Task";
  }

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final hasNotificationPermission = state.hasNotificationPermission;
        final canScheduleReminder =
            !Platform.isAndroid || hasNotificationPermission;

        final hasReminder = homeCubit.state.selectedDateTime != null;
        return BottomSheetMainFrame(
          label: getSheetTitle(),
          initialChildSize: 0.7,
          minChildSize: 0.6,
          content: (scrollController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(16.h),
                TextField(
                  controller: homeCubit.titleController,
                  onChanged: homeCubit.updateTaskTitle,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                ),
                Gap(12.h),
                TextField(
                  controller: homeCubit.descriptionController,
                  onChanged: homeCubit.updateTaskTitle,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                Gap(12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Set Reminder',
                      style: context.textTheme.labelLarge?.withAdaptiveColor(
                        context,
                        lightColor: AppColors.colorNeutral900,
                        darkColor: AppColors.colorNeutralDark900,
                      ),
                    ),
                    if (!canScheduleReminder)...[
                      Gap(8.w),
                      IconButton(
                        icon: const Icon(Icons.info_outline, color: Colors.grey),
                        onPressed: () {
                          kAppShowDialog(
                            context,
                            whenComplete: () {},
                            builder: (dialogContext) {
                              return NotificationPermissionDialogue(
                                dialogContext: dialogContext,
                              );
                            },
                          );
                        },
                      ),
                    ]
                  ],
                ),
                Text(
                  homeCubit.state.selectedDateTime != null
                      ? homeCubit.state.selectedDateTime.toString()
                      : 'No reminder set',
                  style: context.textTheme.bodySmall?.withAdaptiveColor(
                    context,
                    lightColor: AppColors.colorNeutral900,
                    darkColor: AppColors.colorNeutralDark900,
                  ),
                ),
                if (homeCubit.state.selectedDateTime != null &&
                    homeCubit.state.selectedDateTime!.isBefore(
                      DateTime.now(),
                    )) ...[
                  Gap(8.h),
                  Text(
                    "*Please select a future date & time",
                    style: context.textTheme.bodySmall?.withAdaptiveColor(
                      context,
                      lightColor: Colors.red,
                      darkColor: Colors.red,
                    ),
                  ),
                ],
                Gap(12.h),
                if (canScheduleReminder) ...[
                  PrimaryCta(
                    onTap: () {
                      _pickDateTime(context, homeCubit);
                    },
                    label: 'Pick Date & Time',
                  ),
                ] else ...[
                  PrimaryCta(
                    isButtonDisable: true,
                    onTap: () {},
                    label: 'Pick Date & Time',
                  ),
                ],
                Gap(12.h),
                Text(
                  'Select Recurrence',
                  style: context.textTheme.labelLarge?.withAdaptiveColor(
                    context,
                    lightColor: AppColors.colorNeutral900,
                    darkColor: AppColors.colorNeutralDark900,
                  ),
                ),
                Gap(12.h),
                DropdownButton<Recurrence>(
                  value: homeCubit.state.selectedRecurrence,
                  items: homeCubit.state.selectedDateTime != null
                      ? Recurrence.values.where((r) => r != Recurrence.none).map((r) {
                    return DropdownMenuItem(
                      value: r,
                      child: Text(r.name.toUpperCase()),
                    );
                  }).toList()
                      : [
                    DropdownMenuItem(
                      value: Recurrence.none,
                      child: const Text('NONE'),
                    )
                  ],
                  onChanged: homeCubit.state.selectedDateTime != null
                      ? (value) => homeCubit.setSelectedRecurrenceForTask(value!)
                      : null,
                ),
                Gap(12.h),
                PrimaryCta(
                  isButtonDisable: homeCubit.titleController.text.isEmpty ||
                      homeCubit.descriptionController.text.isEmpty ||
                      (homeCubit.state.selectedDateTime != null && homeCubit.state.selectedDateTime!.isBefore(DateTime.now())),
                  onTap: () async {
                    await homeCubit.addTask(context);
                  },
                  label: 'Add Task',
                ),
                Gap(20.h),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _pickDateTime(BuildContext context, HomeCubit homeCubit) async {
    if (Platform.isIOS) {
      DateTime now = DateTime.now();
      DateTime minimumDate = now;
      DateTime initialDateTime = now.isBefore(minimumDate) ? minimumDate : now;
      DateTime? selectedDateTime = await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (_) {
          DateTime tempPickedDate = initialDateTime;
          return Container(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: initialDateTime,
                    minimumDate: minimumDate,
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (DateTime newDateTime) {
                      tempPickedDate = newDateTime;
                    },
                  ),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    Navigator.of(context).pop(tempPickedDate);
                  },
                ),
              ],
            ),
          );
        },
      );

      if (selectedDateTime != null) {
        homeCubit.setSelectedDateTimeForTask(selectedDateTime);
      }
    } else {
      final date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: DateTime.now(),
      );
      if (!context.mounted || date == null) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (!context.mounted || time == null) return;

      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      homeCubit.setSelectedDateTimeForTask(selectedDateTime);
    }
  }
}
