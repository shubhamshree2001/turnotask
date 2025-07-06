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
import 'package:turnotask/modules/home/ui/widgets/set_app_theme_bottomsheet.dart';
import 'package:turnotask/widgets/kapp_widget.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        List<Task> completedTasks = homeCubit.state.completedTask;
        List<Task> inProgressTasks = homeCubit.state.inProgressTask;
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tabBarTopView(context, inProgressTasks, completedTasks),
                tabBarListView(inProgressTasks, homeCubit, completedTasks),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget tabBarListView(
    List<Task> inProgressTasks,
    HomeCubit homeCubit,
    List<Task> completedTasks,
  ) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: _buildVerticalTaskList(inProgressTasks, homeCubit),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: _buildVerticalTaskList(completedTasks, homeCubit, true),
          ),
        ],
      ),
    );
  }

  Widget tabBarTopView(
    BuildContext context,
    List<Task> inProgressTasks,
    List<Task> completedTasks,
  ) {
    return Container(
      width: double.infinity,
      height: 0.435.sh,
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
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.alarm,
                color: context.isLightTheme
                    ? AppColors.colorNeutralDark900
                    : AppColors.colorNeutral900,
                size: 45.w,
              ),
              Gap(12.h),
              Text(
                'Reminders',
                style: context.textTheme.headlineSmall?.withAdaptiveColor(
                  context,
                  lightColor: AppColors.colorNeutralDark900,
                  darkColor: AppColors.colorNeutral900,
                ),
              ),
              Gap(20.h),
              tabSelectionButtonView(inProgressTasks, completedTasks),
            ],
          ),
        ],
      ),
    );
  }

  Widget tabSelectionButtonView(
    List<Task> inProgressTasks,
    List<Task> completedTasks,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.completedColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.transparent,
        labelPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
        indicator: BoxDecoration(
          color: AppColors.inProgressColor.withOpacity(0.9),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        tabs: [
          buildTab('In Progress', inProgressTasks.length),
          buildTab('Completed', completedTasks.length),
        ],
      ),
    );
  }

  Widget buildTab(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: context.textTheme.labelLarge?.withAdaptiveColor(
            context,
            lightColor: AppColors.white,
            darkColor: AppColors.colorNeutral900,
          ),
        ),
        Gap(8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$count',
            style: context.textTheme.bodySmall?.withAdaptiveColor(
              context,
              lightColor: AppColors.colorNeutral900,
              darkColor: AppColors.colorNeutral900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalTaskList(
    List<Task> tasks,
    HomeCubit homeCubit, [
    bool fromCompleteTaskList = false,
  ]) {
    if (tasks.isEmpty) {
      if (fromCompleteTaskList) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //AppImages.emptyTask.toSvg(),
            Text(
              'No Completed Task!',
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge?.withAdaptiveColor(
                context,
                lightColor: AppColors.colorNeutral900,
                darkColor: AppColors.colorNeutralDark900,
              ),
            ),
          ],
        );
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AppImages.emptyTask.toSvg(),
            Text(
              'No Pending Task!',
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge?.withAdaptiveColor(
                context,
                lightColor: AppColors.colorNeutral900,
                darkColor: AppColors.colorNeutralDark900,
              ),
            ),
          ],
        );
      }
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            decoration: BoxDecoration(
              color: task.isCompleted
                  ? context.isLightTheme
                        ? AppColors.completedColor
                        : AppColors.completedColor
                  : context.isLightTheme
                  ? AppColors.inProgressColor
                  : AppColors.inProgressColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(0, 4),
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
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          task.isCompleted
                              ? AppImages.checkIcon.toSvg(
                                  height: 38.w,
                                  width: 38.w,
                                )
                              : AppImages.scheduleIcon.toSvg(
                                  height: 38.w,
                                  width: 38.w,
                                ),
                          Gap(12.w),
                          taskDescAndActionContent(task, context, homeCubit),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.dateTime != null && !task.isCompleted) ...[
                        Gap(4.h),
                        taskDetailText(
                          homeCubit.formatDateTime(task.dateTime.toString()),
                          context,
                        ),
                      ],
                      if (task.isCompleted && task.completionTime != null) ...[
                        Gap(4.h),
                        taskDetailText(
                          homeCubit.formatDateTime(
                            task.completionTime.toString(),
                          ),
                          context,
                        ),
                      ],
                    ],
                  ),
                ),
                if (!task.isCompleted) ...[
                  if (task.dateTime == null) ...[Gap(8.h)],
                  Gap(4.h),
                  markDoneButton(homeCubit, task, context),
                ],
              ],
            ),
          ),
          if (task.recurrence != Recurrence.none) ...[
            recurrenceLabel(task, context),
          ],
        ],
      ),
    );
  }

  Expanded taskDescAndActionContent(
    Task task,
    BuildContext context,
    HomeCubit homeCubit,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          taskTitleText(task, context),
          Gap(4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              taskDescText(task.description, context),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!task.isCompleted) ...[
                    InkWell(
                      onTap: () async {
                        await homeCubit.setDataToEditTask(task.id);
                        if (!mounted) return;
                        kAppShowModalBottomSheet(
                          context,
                          CreateTaskBottomSheet(taskIDByEdit: task.id),
                        );
                      },
                      child: AppImages.editIcon.toSvg(),
                    ),
                    Gap(8.w),
                  ],
                  InkWell(
                    onTap: () async {
                      await homeCubit.deleteTask(task.id);
                      if (!mounted) return;
                      showCenterSnackBar(
                        context,
                        "Task Deleted!",
                        AppImages.deleteIcon,
                      );
                    },
                    child: AppImages.deleteIcon.toSvg(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget markDoneButton(HomeCubit homeCubit, Task task, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.labelColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24.r),
              onTap: () {
                homeCubit.markAsCompleted(task, task.id);
                showCenterSnackBar(
                  context,
                  "Task completed!",
                  AppImages.snoozeIcon,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.w),
                child: Text(
                  'Mark Done',
                  style: context.textTheme.displaySmall?.withAdaptiveColor(
                    context,
                    lightColor: AppColors.colorNeutral900,
                    darkColor: AppColors.colorNeutral900,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget recurrenceLabel(Task task, BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
        decoration: BoxDecoration(
          color: AppColors.labelColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(8.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.alarm, size: 14.w, color: AppColors.colorNeutral900),
            Gap(4.w),
            taskDetailText(task.recurrence.name.toUpperCase(), context, true),
          ],
        ),
      ),
    );
  }

  Widget taskTitleText(Task task, BuildContext context) {
    return Text(
      task.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.labelLarge?.withAdaptiveColor(
        context,
        lightColor: AppColors.white,
        darkColor: AppColors.white,
      ),
    );
  }

  Widget taskDetailText(
    String text,
    BuildContext context, [
    bool recurrenceColor = false,
  ]) {
    return Text(
      text,
      style: context.textTheme.displaySmall?.withAdaptiveColor(
        context,
        lightColor: recurrenceColor ? AppColors.black : AppColors.white,
        darkColor: recurrenceColor ? AppColors.black : AppColors.white,
        fontWeight: recurrenceColor ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget taskDescText(String text, BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: context.textTheme.displaySmall?.withAdaptiveColor(
        context,
        lightColor: AppColors.white,
        darkColor: AppColors.white,
        height: 100 / 100,
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
