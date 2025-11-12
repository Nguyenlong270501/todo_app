import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_todo_app/core/utils/extensions.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/route/app_router.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../profile/presentation/widgets/profile_header.dart';
import '../../../blocs/task/task_cubit.dart';
import 'widgets/date_picker_section.dart';
import 'widgets/task_list_section.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static var currentdate = DateTime.now();
  static var uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    // _clearOldTasksFromFirestore();
  }

  void _loadTasks() {
    context.read<TaskCubit>().getTasks(
      DateFormat('yyyy-MM-dd').format(currentdate),
      uid!,
    );
  }

  // Future<void> _clearOldTasksFromFirestore() async {
  //   if (uid == null) return;
  //   final prefs = await SharedPreferences.getInstance();
  //   final now = DateTime.now();
  //   final todayStr = DateFormat('yyyy-MM-dd').format(now);
  //   final lastChecked = prefs.getString('last_checked_date');
  //   debugPrint('lastChecked: $lastChecked');
  //   if (lastChecked == null || lastChecked != todayStr) {
  //     final tasksSnapshot =
  //         await FirebaseFirestore.instance
  //             .collection('users')
  //             .doc(uid)
  //             .collection('tasks')
  //             .get();
  //     for (var doc in tasksSnapshot.docs) {
  //       final taskDate = doc['date'];
  //       if (taskDate.compareTo(todayStr) < 0) {
  //         await doc.reference.delete();
  //       }
  //     }
  //     await prefs.setString('last_checked_date', todayStr);
  //   }
  // }

  void _onDateSelected(DateTime newdate) {
    setState(() {
      if (newdate.year == DateTime.now().year &&
          newdate.month == DateTime.now().month &&
          newdate.day == DateTime.now().day) {
        currentdate = DateTime.now();
      } else {
        currentdate = newdate;
      }
    });
    _loadTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileSection(),
              AppSizes.gapH4,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    color: context.theme.primaryColor,
                    width: 150.w,
                    title: 'View Weekly',
                    onClick: () {
                      context.pushNamed(
                        RouteNames.weeklypage,
                        extra: {'date': currentdate},
                      );
                    },
                  ),
                  const Spacer(),
                  AppButton(
                    color: context.theme.primaryColor,
                    width: 150.w,
                    title: '+ Add Task',
                    onClick: () {
                      context.pushNamed(
                        RouteNames.addtaskpage,
                        extra: {'date': currentdate},
                      );
                    },
                  ),
                ],
              ),
              AppSizes.gapH24,
              DatePickerSection(
                currentDate: currentdate,
                onDateSelected: (DateTime newdate) {
                  _onDateSelected(newdate);
                },
              ),
              AppSizes.gapH24,
              Row(
                children: [
                  Icon(Icons.calendar_month, color: context.theme.primaryColor),
                  AppSizes.gapW8,
                  Text("All The Tasks For  ", style: AppTypography.medium14()),
                  Text(
                    DateFormat('yyyy-MM-dd').format(currentdate),
                    style: AppTypography.medium14(
                      color: context.theme.primaryColor,
                    ),
                  ),
                ],
              ),
              AppSizes.gapH12,
              Expanded(
                child: TaskListSection(selectedDate: currentdate, uid: uid!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
