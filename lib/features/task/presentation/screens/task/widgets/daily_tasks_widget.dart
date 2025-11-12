import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/route/app_router.dart';
import '../../../../../../core/theme/app_styles.dart';
import '../../../../../../core/theme/app_thems.dart';
import '../../../../../../core/utils/extensions.dart';
import '../../../../../../core/widgets/app_circular_indicator.dart';
import '../../../../data/models/task_model.dart';
import '../../../../data/repository/task_repository.dart';
import 'task_card.dart';

class DailyTasksWidget extends StatelessWidget {
  final DateTime selectedDate;
  final String uid;

  const DailyTasksWidget({
    super.key,
    required this.selectedDate,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: TaskRepository().getTasksStream(
        DateFormat('yyyy-MM-dd').format(selectedDate),
        uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.w,
                  color: context.theme.primaryColor,
                ),
                AppSizes.gapH16,
                Text('Error loading tasks', style: AppTypography.medium16()),
                AppSizes.gapH8,
                Text(
                  '${snapshot.error}',
                  style: AppTypography.medium12(
                    color: context.theme.textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppCircularIndicator();
        }

        final tasks = snapshot.data ?? [];

        return tasks.isNotEmpty
            ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                Widget taskContainer = TaskCard(
                  uid: uid,
                  id: task.id ?? '',
                  color:
                      AppTheme
                          .themes[AppThemeColor.values[task.colorIndex ?? 0]]!
                          .primaryColor,
                  title: task.title ?? '',
                  time: task.time ?? '',
                  note: task.note ?? '',
                  selectedDate: selectedDate,
                );

                return InkWell(
                  onTap:
                      () => context.pushNamed(
                        RouteNames.addtaskpage,
                        extra: {'task': task, 'date': selectedDate},
                      ),
                  child:
                      index % 2 == 0
                          ? BounceInLeft(
                            duration: const Duration(milliseconds: 600),
                            child: taskContainer,
                          )
                          : BounceInRight(
                            duration: const Duration(milliseconds: 600),
                            child: taskContainer,
                          ),
                );
              },
            )
            : _buildNoDataWidget(context);
      },
    );
  }

  Widget _buildNoDataWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.clipboard,
            width: 100.w,
            height: 100.h,
            color: context.theme.primaryColor.withOpacity(0.3),
          ),
          AppSizes.gapH24,
          Text(
            'No tasks for this day',
            style: AppTypography.medium16(
              color: context.theme.textTheme.bodyMedium?.color,
            ),
          ),
          AppSizes.gapH8,
          Text(
            'Tap the + Add Task button to create your first task',
            style: AppTypography.medium12(
              color: context.theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
