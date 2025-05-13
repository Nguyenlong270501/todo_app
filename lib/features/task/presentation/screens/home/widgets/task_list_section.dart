import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/route/app_router.dart';
import '../../../../../../core/theme/app_styles.dart';
import '../../../../../../core/theme/app_thems.dart';

import '../../../../../../core/widgets/app_circular_indicator.dart';

import '../../../../data/models/task_model.dart';
import '../../../../data/repository/task_repository.dart';
import 'task_card.dart';

class TaskListSection extends StatelessWidget {
  final DateTime selectedDate;
  final String uid;

  const TaskListSection({
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
          return Center(child: Text('Error: ${snapshot.error}'));
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
                Widget taskcontainer = TaskCard(
                  uid: uid,
                  id: task.id ?? const Uuid().v4(),
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
                            duration: const Duration(milliseconds: 1000),
                            child: taskcontainer,
                          )
                          : BounceInRight(
                            duration: const Duration(milliseconds: 1000),
                            child: taskcontainer,
                          ),
                );
              },
            )
            : _buildNoDataWidget();
      },
    );
  }

  Widget _buildNoDataWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppAssets.clipboard, width: 100.w, height: 100.h),
          AppSizes.gapH24,
          Text('No Tasks for this date', style: AppTypography.medium14()),
        ],
      ),
    );
  }
}
