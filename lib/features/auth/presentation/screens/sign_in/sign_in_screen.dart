import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/route/app_router.dart';
import '../../../../../core/theme/app_styles.dart';
import '../../../../../core/widgets/app_alerts.dart';
import '../../../blocs/authentication/authentication_cubit.dart';
import '../../widgets/auth_divider.dart';
import '../../widgets/auth_oauth_section.dart';
import 'widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccessState) {
            context.goNamed(RouteNames.homepage);
          } else if (state is AuthenticationErrortate) {
            Alerts.of(context).showError(state.error);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppSizes.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back',
                    style: AppTypography.bold24().copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSizes.gapH12,
                  Text(
                    'Login to your account',
                    style: AppTypography.medium14().copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  AppSizes.gapH32,
                  const SignInForm(),
                  AppSizes.gapH24,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(RouteNames.forgotpasswordpage);
                      },
                      child: Text(
                        'Forgot password?',
                        style: AppTypography.medium14().copyWith(
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  AppSizes.gapH12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: AppTypography.medium14(),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(RouteNames.signuppage);
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTypography.medium14(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSizes.gapH24,
                  const AuthDivider(),
                  AppSizes.gapH24,
                  const AuthOauthSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
