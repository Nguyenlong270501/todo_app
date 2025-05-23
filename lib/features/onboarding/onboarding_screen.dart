import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'cubit/onboarding_cubit.dart';
import 'cubit/onboarding_state.dart';
import 'widgets/on_boarding_page_indicator.dart';
import 'widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          OnboardingCubit cubit = BlocProvider.of(context);
          return Column(
            children: [
              OnboardingContent(
                pageController: _pageController,
                cubit: cubit,
              ),
              SizedBox(
                height: 100.h,
                child: OnBoardingPageIndicator(pageController: _pageController),
              ),
            ],
          );
        },
      ),
    );
  }
}
