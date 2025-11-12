import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/theme/app_styles.dart';
import '../../../../../../core/utils/extensions.dart';

class WeeklyCalendarWidget extends StatelessWidget {
  final List<DateTime> weekDays;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeeklyCalendarWidget({
    super.key,
    required this.weekDays,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header với tên các ngày trong tuần
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children:
                  weekDays.map((day) {
                    final isToday = _isSameDay(day, DateTime.now());
                    return Expanded(
                      child: Center(
                        child: Text(
                          DateFormat('E').format(day),
                          style: AppTypography.medium14(
                            color:
                                isToday
                                    ? context.theme.primaryColor
                                    : context.theme.textTheme.bodyMedium?.color,
                          ).copyWith(
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          // Các ngày trong tuần
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children:
                  weekDays.map((day) {
                    final isSelected = _isSameDay(day, selectedDate);
                    final isToday = _isSameDay(day, DateTime.now());
                    final isCurrentMonth = day.month == DateTime.now().month;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onDateSelected(day),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? context.theme.primaryColor
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                            border:
                                isToday && !isSelected
                                    ? Border.all(
                                      color: context.theme.primaryColor,
                                      width: 2,
                                    )
                                    : null,
                          ),
                          child: Column(
                            children: [
                              Text(
                                day.day.toString(),
                                style: AppTypography.medium16(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : isCurrentMonth
                                          ? context
                                              .theme
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                          : context
                                              .theme
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.5),
                                ).copyWith(
                                  fontWeight:
                                      isSelected || isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              AppSizes.gapH4,
                              // Hiển thị số lượng tasks (có thể thêm sau)
                              Container(
                                width: 6.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : context.theme.primaryColor
                                              .withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
