import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/sign_in/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up/sign_up_screen.dart';
import '../../features/auth/presentation/widgets/forgot_password_screens.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/spalash/spalash_screen.dart';
import '../../features/task/data/models/task_model.dart';
import '../../features/task/presentation/screens/home/home_screen.dart';
import '../../features/task/presentation/screens/task/task_screen.dart';
import '../../features/welcome/welcome_screen.dart';

class RouteNames {
  static const String onboarding = "/onboarding";
  static const String welcomepage = "/welcome";
  static const String loginpage = "/login";
  static const String signuppage = "/signup";
  static const String homepage = "/homepage";
  static const String addtaskpage = "/addtask";
  static const String settingspage = "/settings";
  static const String forgotpasswordpage = "/forgotpassword";
}

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: "/",
        name: "/",
        builder: (context, state) => const SPlashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.welcomepage,
        name: RouteNames.welcomepage,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: RouteNames.loginpage,
        name: RouteNames.loginpage,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotpasswordpage,
        name: RouteNames.forgotpasswordpage,
        builder: (context, state) => const ForgotPasswordScreens(),
      ),
      GoRoute(
        path: RouteNames.signuppage,
        name: RouteNames.signuppage,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RouteNames.homepage,
        name: RouteNames.homepage,
        builder: (context, state) => const MyHomePage(),
      ),
      GoRoute(
        path: RouteNames.addtaskpage,
        name: RouteNames.addtaskpage,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          final task = data?['task'] as TaskModel?;
          final DateTime date = data?['date'] as DateTime;
          return AddTaskScreen(task: task, date: date);
        },
      ),
      GoRoute(
        path: RouteNames.settingspage,
        name: RouteNames.settingspage,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
