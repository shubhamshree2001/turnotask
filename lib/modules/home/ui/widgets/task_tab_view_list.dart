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
import 'package:turnotask/modules/home/ui/widgets/primary_cta.dart';
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
        final completedTasks = homeCubit.state.allTask
            .where((t) => t.isCompleted)
            .toList();
        final inProgressTasks = homeCubit.state.allTask
            .where((t) => !t.isCompleted)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(12.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                color: context.isLightTheme
                    ? AppColors.primaryColor.withOpacity(0.4)
                    : AppColors.primaryColor.withOpacity(0.7),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColors.transparent,
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                indicator: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                labelPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.w,
                ),
                tabs: [
                  _buildTab('In Progress', inProgressTasks.length),
                  _buildTab('Completed', completedTasks.length),
                ],
              ),
            ),
            Gap(12.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVerticalTaskList(inProgressTasks, homeCubit),
                  _buildVerticalTaskList(completedTasks, homeCubit, true),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTab(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: context.textTheme.labelLarge?.withAdaptiveColor(
            context,
            lightColor: AppColors.colorNeutral900,
            darkColor: AppColors.colorNeutral900,
          ),
        ),
        Gap(4.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
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
          children: [
            AppImages.emptyTask.toSvg(),
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
          children: [
            AppImages.emptyTask.toSvg(),
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
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
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      task.isCompleted
                          ? Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Icon(
                                Icons.check,
                                size: 24.w,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.pending_actions,
                              color: Colors.orange,
                              size: 24.w,
                            ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            taskTitleText(task, context),
                            Gap(4.w),
                            taskDescText(task.description, context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(8.w),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 24.w),
                  tooltip: 'Delete',
                  onPressed: () async {
                    await homeCubit.deleteTask(index);
                    if (!mounted) return;
                    showCenterSnackBar(context, "Task deleted successfully!");
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 36.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            ),
            if (!task.isCompleted) ...[
              Gap(8.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryCta(
                    onTap: () {
                      homeCubit.markAsCompleted(task, index);
                      showCenterSnackBar(context, "Task completed successfully!");
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

  Widget taskTitleText(Task task, BuildContext context) {
    return Text(
      task.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: context.textTheme.labelLarge?.withAdaptiveColor(
        context,
        lightColor: AppColors.colorNeutral900,
        darkColor: AppColors.colorNeutral900,
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

  Widget taskDescText(String text, BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: context.textTheme.displaySmall?.withAdaptiveColor(
        context,
        lightColor: AppColors.colorNeutral700,
        darkColor: AppColors.colorNeutral700,
      ),
    );
  }
}
