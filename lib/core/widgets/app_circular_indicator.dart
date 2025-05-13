import 'package:flutter/material.dart';
import 'package:my_todo_app/core/utils/extensions.dart';

class AppCircularIndicator extends StatelessWidget {
  const AppCircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.theme.primaryColor,
      ),
    );
  }
}
