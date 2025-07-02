import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/data/theme/bloc/theme_cubit.dart';
import 'package:turnotask/modules/home/bloc/home_cubit.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/modules/home/ui/widgets/primary_cta.dart';
import 'package:turnotask/services/notification_service.dart';
import 'package:turnotask/widgets/bottom_sheet_mainframe.dart';

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
                  decoration: const InputDecoration(labelText: 'Task Title'),
                ),
                Gap(12.h),
                TextField(
                  controller: homeCubit.descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                Gap(12.h),
                Text(
                  homeCubit.state.selectedDateTime == null
                      ? 'Select Date/Time'
                      : homeCubit.state.selectedDateTime.toString(),
                  style: context.textTheme.labelLarge?.withAdaptiveColor(
                    context,
                    lightColor: AppColors.colorNeutral900,
                    darkColor: AppColors.colorNeutralDark900,
                  ),
                ),
                Gap(12.h),
                PrimaryCta(
                  onTap: () {
                    _pickDateTime(homeCubit);
                  },
                  label: 'Pick Date & Time',
                ),
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
                  items: Recurrence.values.map((r) {
                    return DropdownMenuItem(
                      value: r,
                      child: Text(r.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      homeCubit.setSelectedRecurrenceForTask(value!),
                ),
                Gap(12.h),
                PrimaryCta(
                  isButtonDisable:
                      homeCubit.titleController.text.isEmpty ||
                      homeCubit.descriptionController.text.isEmpty ||
                      homeCubit.state.selectedDateTime == null,
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

  Future<void> _pickDateTime(HomeCubit homeCubit) async {
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
    DateTime selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    homeCubit.setSelectedDateTimeForTask(selectedDateTime);
  }
}
