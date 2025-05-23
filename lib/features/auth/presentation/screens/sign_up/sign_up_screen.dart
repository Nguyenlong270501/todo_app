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
import 'widgets/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccessState) {
          context.goNamed(RouteNames.homepage);
        } else if (state is AuthenticationErrortate) {
          Alerts.of(context).showError(state.error.toString());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: AppSizes.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Create Account',
                    style: AppTypography.bold24().copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  AppSizes.gapH12,
                  Text(
                    'Fill in your details to get started',
                    style: AppTypography.medium14().copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  AppSizes.gapH32,
                  SignUpForm(),
                  AppSizes.gapH24,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.medium14(),
                      ),
                      InkWell(
                        onTap: () => context.pop(),
                        child: Text(
                          'Login',
                          style: AppTypography.medium14(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSizes.gapH24,
                  AuthDivider(),
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
