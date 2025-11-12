import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../core/route/app_router.dart';
import '../../../../../core/theme/app_thems.dart';
import '../../../../../core/widgets/app_circular_indicator.dart';
import '../../../blocs/task/task_cubit.dart';

class WeeklyCalendarScreen extends StatefulWidget {
  final DateTime? initialDate;

  const WeeklyCalendarScreen({super.key, this.initialDate});

  @override
  State<WeeklyCalendarScreen> createState() => _WeeklyCalendarScreenState();
}

class _WeeklyCalendarScreenState extends State<WeeklyCalendarScreen> {
  late DateTime _currentWeekStart;
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _loadWeeklyTasks();
  }

  void _initializeDates() {
    final now = DateTime.now();
    final initialDate = widget.initialDate ?? now;
    _currentWeekStart = _getWeekStart(initialDate);
  }

  void _loadWeeklyTasks() {
    if (_uid != null) {
      context.read<TaskCubit>().getWeeklyTasks(_currentWeekStart, _uid);
    }
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  void _navigateWeek(int direction) {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: direction * 7));
    });
    _loadWeeklyTasks();
  }

  List<DateTime> _getWeekDays() {
    return List.generate(
      7,
      (index) => _currentWeekStart.add(Duration(days: index)),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view weekly calendar')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Calendar'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final now = DateTime.now();
              context.pushNamed(RouteNames.addtaskpage, extra: {'date': now});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header với điều hướng tuần
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _navigateWeek(-1),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text(
                        '${DateFormat('MMM dd').format(_currentWeekStart)} - ${DateFormat('MMM dd').format(_currentWeekStart.add(const Duration(days: 6)))}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _navigateWeek(1),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('yyyy').format(_currentWeekStart),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Hiển thị tasks của cả tuần
            Expanded(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: AppCircularIndicator());
                  } else if (state is WeeklyTasksLoaded) {
                    final weeklyTasks = state.weeklyTasks;
                    final weekDays = _getWeekDays();

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: weekDays.length,
                      itemBuilder: (context, dayIndex) {
                        final day = weekDays[dayIndex];
                        final dayStr = DateFormat('yyyy-MM-dd').format(day);
                        final tasksForDay = weeklyTasks[dayStr] ?? [];
                        final isToday = _isSameDay(day, DateTime.now());

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header cho ngày
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      isToday
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[100],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                      color:
                                          isToday
                                              ? Colors.white
                                              : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('EEEE').format(day),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  isToday
                                                      ? Colors.white
                                                      : Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            DateFormat(
                                              'MMM dd, yyyy',
                                            ).format(day),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  isToday
                                                      ? Colors.white
                                                          .withOpacity(0.8)
                                                      : Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isToday
                                                ? Colors.white.withOpacity(0.2)
                                                : Theme.of(
                                                  context,
                                                ).primaryColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        '${tasksForDay.length} tasks',
                                        style: TextStyle(
                                          color:
                                              isToday
                                                  ? Colors.white
                                                  : Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Danh sách tasks cho ngày
                              if (tasksForDay.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children:
                                        tasksForDay.map((task) {
                                          return Card(
                                            margin: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              leading: Container(
                                                width: 4,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppTheme
                                                          .themes[AppThemeColor
                                                              .values[task
                                                                  .colorIndex ??
                                                              0]]!
                                                          .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                ),
                                              ),
                                              title: Text(
                                                task.title ?? '',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              subtitle:
                                                  task.note?.isNotEmpty == true
                                                      ? Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              top: 4,
                                                            ),
                                                        child: Text(
                                                          task.note!,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                            height: 1.3,
                                                          ),
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      )
                                                      : null,
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (task.time?.isNotEmpty ==
                                                      true)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .primaryColor
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        task.time!,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Theme.of(
                                                                context,
                                                              ).primaryColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  const SizedBox(width: 8),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 14,
                                                    color: Colors.grey[400],
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                context.pushNamed(
                                                  RouteNames.addtaskpage,
                                                  extra: {
                                                    'task': task,
                                                    'date': day,
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.task_alt_outlined,
                                          size: 48,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'No tasks for this day',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Tap + to add a task',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is TaskError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${state.message}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadWeeklyTasks,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
