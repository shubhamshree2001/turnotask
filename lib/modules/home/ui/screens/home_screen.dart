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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeCubit.state.allTask.isEmpty
                  ? Expanded(child: noTaskView(context))
                  : Expanded(child: TaskListView()),
              Gap(20.h),
            ],
          ),
        );
      },
    );
  }

  Widget noTaskView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 40.h,
              bottom: 30.h,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
              ],
              color: AppColors.primaryColorNew,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Taskly',
                  style: context.textTheme.headlineLarge?.withAdaptiveColor(
                    context,
                    lightColor: AppColors.colorNeutralDark900,
                    darkColor: AppColors.colorNeutral900,
                  ),
                ),
                setAppTheme(context),
              ],
            ),
          ),
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
    );
  }

  Widget setAppTheme(BuildContext context) {
    return IconButton(
      onPressed: () {
        kAppShowModalBottomSheet(context, const SetAppThemeBottomSheet());
      },
      icon: AppImages.appTheme.toSvg(
        height: 30.w,
        width: 30.w,
        color: context.isLightTheme
            ? AppColors.colorNeutralDark900
            : AppColors.colorNeutral900,
      ),
    );
  }
}
