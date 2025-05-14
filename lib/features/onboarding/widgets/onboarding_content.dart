import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:my_todo_app/core/utils/extensions.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/route/app_router.dart';
import '../cubit/onboarding_cubit.dart';
import 'onboard_item.dart';
import 'onboarding_custom_painter.dart';

class OnboardingContent extends StatelessWidget {
  final PageController pageController;
  final OnboardingCubit cubit;

  const OnboardingContent({
    super.key,
    required this.pageController,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: CustomPaint(
        painter: OnboardingCustomPainter(color: Colors.white),
        child: Stack(
          children: [
            PageView(
              physics: const BouncingScrollPhysics(),
              controller: pageController,
              children: [
                OnBoardItem(
                  image: AppAssets.onboradingone,
                  title: 'Manage Your Task',
                  description:
                      'Stay organized and boost your productivity with this all-in-one task management app. '
                      'Easily create, edit, and track your to-dos, ensuring that no important task slips through the cracks.',
                ),
                OnBoardItem(
                  image: AppAssets.onboradingtwo,
                  title: 'Plan Your Day with Ease',
                  description:
                      'Seamlessly schedule your daily tasks and let the app handle the reminders for you. '
                      'Stay on top of your commitments and make the most out of every day without worrying about forgetting important duties.',
                ),
                OnBoardItem(
                  image: AppAssets.onboradingthree,
                  title: 'Accomplish Your Goals',
                  description:
                      'Monitor your progress and stay motivated as you work towards completing your goals. '
                      'With an intuitive tracking system, you can measure your accomplishments and keep moving forward with confidence.',
                ),
              ],
            ),
            // Circle Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: ElevatedButton(
                  onPressed: () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                    if (cubit.currentIndex < 2) {
                      cubit.nextPage();
                    } else {
                      context.goNamed(RouteNames.welcomepage);
                      cubit.savePref();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    minimumSize: Size(40.w, 40.h),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
