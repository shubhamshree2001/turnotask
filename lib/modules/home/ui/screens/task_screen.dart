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
import 'package:turnotask/widgets/kapp_widget.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  void initState() {
    super.initState();
    //NotificationService().registerMarkDoneCallback(_markAsCompletedFromNotification);
  }

  // void _markAsCompletedFromNotification(int taskId) async {
  //   final index = _tasksBox.values.toList().indexWhere((t) => t.id == taskId);
  //   if (index != -1) {
  //     final task = _tasksBox.getAt(index);
  //     if (task != null && !task.isCompleted) {
  //       _markAsCompleted(task, index);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          kAppShowModalBottomSheet(context, const CreateTaskBottomSheet());
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: context.isLightTheme ? Colors.green : Colors.green,
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final HomeCubit homeCubit = context.read<HomeCubit>();
          return Padding(
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
                            'There is no task.',
                            style: context.textTheme.labelLarge
                                ?.withAdaptiveColor(
                                  context,
                                  lightColor: AppColors.colorNeutral900,
                                  darkColor: AppColors.colorNeutralDark900,
                                ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: homeCubit.state.allTask.length,
                          itemBuilder: (context, index) {
                            final task = homeCubit.state.allTask[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.w),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.w,
                                ),
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 16.w,
                                      height: 16.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: task.isCompleted
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                      child: Icon(
                                        task.isCompleted
                                            ? Icons.check
                                            : Icons.circle,
                                        size: 16.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Gap(12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.title,
                                            style: context.textTheme.labelLarge
                                                ?.withAdaptiveColor(
                                                  context,
                                                  lightColor: AppColors
                                                      .colorNeutralDark900,
                                                  darkColor:
                                                      AppColors.colorNeutral900,
                                                ),
                                          ),
                                          Gap(4.w),
                                          Text(
                                            task.description,
                                            style: context
                                                .textTheme
                                                .displaySmall
                                                ?.withAdaptiveColor(
                                                  context,
                                                  lightColor: AppColors
                                                      .colorNeutralDark900,
                                                  darkColor:
                                                      AppColors.colorNeutral900,
                                                ),
                                          ),
                                          Gap(4.w),
                                          Text(
                                            'Created: ${task.dateTime}',
                                            style: context
                                                .textTheme
                                                .displaySmall
                                                ?.withAdaptiveColor(
                                                  context,
                                                  lightColor: AppColors
                                                      .colorNeutralDark900,
                                                  darkColor:
                                                      AppColors.colorNeutral900,
                                                ),
                                          ),
                                          if (task.isCompleted &&
                                              task.completionTime != null)
                                            Text(
                                              'Completed: ${task.completionTime}',
                                              style: context
                                                  .textTheme
                                                  .displaySmall
                                                  ?.withAdaptiveColor(
                                                    context,
                                                    lightColor: AppColors
                                                        .colorNeutralDark900,
                                                    darkColor: AppColors
                                                        .colorNeutral900,
                                                  ),
                                            ),
                                          Gap(4.w),
                                          Text(
                                            'Recurrence: ${task.recurrence.name.toUpperCase()}',
                                            style: context
                                                .textTheme
                                                .displaySmall
                                                ?.withAdaptiveColor(
                                                  context,
                                                  lightColor: AppColors
                                                      .colorNeutralDark900,
                                                  darkColor:
                                                      AppColors.colorNeutral900,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gap(8.w),
                                    if (!task.isCompleted)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.orange,
                                        ),
                                        tooltip: 'Mark as Completed',
                                        onPressed: () {
                                          homeCubit.markAsCompleted(
                                            task,
                                            index,
                                          );
                                        },
                                      ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Delete',
                                      onPressed: () async {
                                        await homeCubit.deleteTask(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  Gap(20.h),
                ],
              ),
            ),
          );
        },
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
