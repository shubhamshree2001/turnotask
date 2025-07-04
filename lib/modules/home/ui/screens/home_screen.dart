import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:turnotask/data/theme/app_colours.dart';
import 'package:turnotask/data/theme/app_theme.dart';
import 'package:turnotask/data/utils/string_extension.dart';
import 'package:turnotask/data/values/app_images.dart';
import 'package:turnotask/modules/home/bloc/home_cubit.dart';
import 'package:turnotask/modules/home/model/task_model.dart';
import 'package:turnotask/modules/home/ui/widgets/create_task_bottomsheet.dart';
import 'package:turnotask/modules/home/ui/widgets/notification_permission_dialogue.dart';
import 'package:turnotask/modules/home/ui/widgets/primary_cta.dart';
import 'package:turnotask/modules/home/ui/widgets/set_app_theme_bottomsheet.dart';
import 'package:turnotask/services/notification_helper.dart';
import 'package:turnotask/widgets/kapp_widget.dart';

class HomeScreen extends StatefulWidget {
  final int? notificationTaskId;

  const HomeScreen({super.key, this.notificationTaskId});

  static pushReplacement(context, [int? notificationTaskId]) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(notificationTaskId: notificationTaskId),
        ),
      );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('Called applifecycle');
    if (state == AppLifecycleState.resumed) {
      updateDataNeeded();
      updateNotificationPermission();
      print('Called applifecycle resumed');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final HomeCubit homeCubit = context.read<HomeCubit>();
      if (Platform.isAndroid) {
        await homeCubit.checkHasExactAlarmNotificationPermission();
      }
    });
    // NotificationService().registerMarkDoneCallback((taskId) {
    //debugPrint('Marking task ${widget.notificationTaskId} as done!');
    //});
  }

  void updateDataNeeded() {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    homeCubit.updateTaskData();
  }

  void updateNotificationPermission() {
    if (Platform.isAndroid) {
      final HomeCubit homeCubit = context.read<HomeCubit>();
      homeCubit.checkHasExactAlarmNotificationPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    final HomeCubit homeCubit = context.read<HomeCubit>();
    homeCubit.descriptionController.dispose();
    homeCubit.titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final HomeCubit homeCubit = context.read<HomeCubit>();
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // if (Platform.isAndroid) {
              //   if (homeCubit.state.hasNotificationPermission) {
              //     kAppShowModalBottomSheet(
              //       context,
              //       const CreateTaskBottomSheet(),
              //     );
              //   } else {
              //     kAppShowDialog(
              //       context,
              //       whenComplete: () {},
              //       builder: (dialogContext) {
              //         return NotificationPermissionDialogue(
              //           dialogContext: dialogContext,
              //         );
              //       },
              //     );
              //   }
              // } else {
              //   kAppShowModalBottomSheet(
              //     context,
              //     const CreateTaskBottomSheet(),
              //   );
              // }
              kAppShowModalBottomSheet(context, const CreateTaskBottomSheet());
            },
            tooltip: 'Add Task',
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            elevation: 6,
            title: Text(
              'TurnoTask',
              style: context.textTheme.labelLarge?.withAdaptiveColor(
                context,
                lightColor: AppColors.colorNeutral900,
                darkColor: AppColors.colorNeutralDark900,
              ),
            ),
            actions: [setAppTheme(context)],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(12.w),
                  homeCubit.state.allTask.isEmpty
                      ? Center(
                          child: Text(
                            'Your task list is empty. Tap + to add a task and set a reminder so you never miss a thing!',
                            textAlign: TextAlign.center,
                            style: context.textTheme.labelLarge
                                ?.withAdaptiveColor(
                                  context,
                                  lightColor: AppColors.colorNeutral900,
                                  darkColor: AppColors.colorNeutralDark900,
                                ),
                          ),
                        )
                      : taskListView(homeCubit),
                  Gap(20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget taskListView(HomeCubit homeCubit) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: homeCubit.state.allTask.length,
      itemBuilder: (context, index) {
        final task = homeCubit.state.allTask[index];
        return taskListItem(task, context, homeCubit, index);
      },
    );
  }

  Widget taskListItem(
    Task task,
    BuildContext context,
    HomeCubit homeCubit,
    int index,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    task.isCompleted
                        ? Container(
                            width: 16.w,
                            height: 16.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 16.w,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.pending_actions, color: Colors.orange),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: context.textTheme.labelLarge
                              ?.withAdaptiveColor(
                                context,
                                lightColor: AppColors.colorNeutral900,
                                darkColor: AppColors.colorNeutral900,
                              ),
                        ),
                        Gap(4.w),
                        taskDetailText(task.description, context),
                      ],
                    ),
                  ],
                ),
                Gap(8.w),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete',
                  onPressed: () async {
                    await homeCubit.deleteTask(index);
                  },
                ),
              ],
            ),
            if (task.dateTime != null) ...[
              Gap(4.w),
              taskDetailText(
                'Reminder added for ${homeCubit.formatDateTime(task.dateTime.toString())}',
                context,
              ),
            ],
            if (task.isCompleted && task.completionTime != null) ...[
              Gap(4.w),
              taskDetailText(
                'Completed on ${homeCubit.formatDateTime(task.completionTime.toString())}',
                context,
              ),
            ],
            if (task.recurrence != Recurrence.none) ...[
              Gap(4.w),
              taskDetailText(
                'Recurrence: ${task.recurrence.name.toUpperCase()}',
                context,
              ),
            ],
            if (!task.isCompleted) ...[
              Gap(8.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryCta(
                    onTap: () {
                      homeCubit.markAsCompleted(task, index);
                    },
                    label: "Mark Done",
                    color: Colors.orange.withOpacity(0.8),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget taskDetailText(String text, BuildContext context) {
    return Text(
      text,
      style: context.textTheme.displaySmall?.withAdaptiveColor(
        context,
        lightColor: AppColors.colorNeutral900,
        darkColor: AppColors.colorNeutral900,
      ),
    );
  }

  Widget setAppTheme(BuildContext context) {
    return IconButton(
      onPressed: () {
        kAppShowModalBottomSheet(context, const SetAppThemeBottomSheet());
      },
      icon: AppImages.paint.toSvg(
        height: 24.w,
        width: 24.w,
        color: context.isDarkTheme
            ? AppColors.colorNeutralDark900
            : AppColors.colorNeutral900,
      ),
    );
  }
}
