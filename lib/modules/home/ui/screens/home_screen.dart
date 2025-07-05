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
import 'package:turnotask/modules/home/ui/widgets/create_task_bottomsheet.dart';
import 'package:turnotask/modules/home/ui/widgets/set_app_theme_bottomsheet.dart';
import 'package:turnotask/modules/home/ui/widgets/task_tab_view_list.dart';
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
        await homeCubit.checkHasNotificationPermissionAndroid();
        await homeCubit.checkHasExactAlarmNotificationPermission();
      } else {
        await homeCubit.checkHasNotificationPermissionIos();
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
    final HomeCubit homeCubit = context.read<HomeCubit>();
    if (Platform.isAndroid) {
      homeCubit.checkHasNotificationPermissionAndroid();
      homeCubit.checkHasExactAlarmNotificationPermission();
    } else {
      homeCubit.checkHasNotificationPermissionIos();
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
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              kAppShowModalBottomSheet(context, const CreateTaskBottomSheet());
            },
            tooltip: 'Add Task',
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            elevation: 6,
            title: Text(
              'Taskly',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                homeCubit.state.allTask.isEmpty
                    ? Expanded(child: noTaskView(context))
                    : Expanded(child: TaskListView()),
                Gap(20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget noTaskView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gap(12.h),
            AppImages.emptyTask.toSvg(),
            Text(
              'No Reminders',
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge?.withAdaptiveColor(
                context,
                lightColor: AppColors.colorNeutral900,
                darkColor: AppColors.colorNeutralDark900,
              ),
            ),
            Gap(8.h),
            Text(
              'Create a reminder and it will show up here.',
              textAlign: TextAlign.center,
              style: context.textTheme.labelLarge?.withAdaptiveColor(
                context,
                lightColor: AppColors.colorNeutral900,
                darkColor: AppColors.colorNeutralDark900,
              ),
            ),
            Gap(24.h),
          ],
        ),
      ),
    );
  }

  // Widget taskListView(HomeCubit homeCubit) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: NeverScrollableScrollPhysics(),
  //     itemCount: homeCubit.state.allTask.length,
  //     itemBuilder: (context, index) {
  //       final task = homeCubit.state.allTask[index];
  //       return taskListItem(task, context, homeCubit, index);
  //     },
  //   );
  // }

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
