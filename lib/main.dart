import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_todo_app/core/route/app_router.dart';
import 'core/di/injection.dart';
import 'core/services/local_notifications_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/theme/theme_cubit.dart';
import 'features/auth/blocs/authentication/authentication_cubit.dart';
import 'features/auth/blocs/log_in_form/login_form_cubit.dart';
import 'features/auth/blocs/sign_up_form/sign_up_form_cubit.dart';
import 'features/onboarding/cubit/onboarding_cubit.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'features/task/blocs/task/task_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await configureDependencies();

  tz.initializeTimeZones();

  await LocalNotificationService().init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt<OnboardingCubit>()),
            BlocProvider(create: (context) => AuthenticationCubit()),
            BlocProvider(create: (context) => LoginFormCubit()),
            BlocProvider(create: (context) => SignUpFormCubit()),
            BlocProvider(create: (context) => TaskCubit()),
            BlocProvider(create: (context) => getIt<ThemeCubit>()),
            BlocProvider(create: (context) => getIt<ProfileCubit>()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeData>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Todo App',
                themeMode: ThemeMode.light,
                theme: state,
                routerConfig: AppRouter().router,
              );
            },
          ),
        );
      },
    );
  }
}
