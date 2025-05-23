import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_todo_app/core/utils/extensions.dart';
import '../../../../../../core/theme/app_styles.dart';

class DatePickerSection extends StatelessWidget {
  final DateTime currentDate;
  final Function(DateTime) onDateSelected;

  const DatePickerSection({
    super.key,
    required this.currentDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      DateTime.now(),
      height: 100.h,
      width: 80.w,
      initialSelectedDate: currentDate,
      selectionColor: context.theme.primaryColor,
      selectedTextColor: Colors.white,
      dateTextStyle: AppTypography.medium14(),
      dayTextStyle: AppTypography.medium14(),
      monthTextStyle: AppTypography.medium14(),
      onDateChange: onDateSelected,
    );
  }
}
