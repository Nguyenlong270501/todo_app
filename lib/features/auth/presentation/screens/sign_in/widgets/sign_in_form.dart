import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/core/utils/extensions.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_textfield.dart';
import '../../../../blocs/authentication/authentication_cubit.dart';
import '../../../../blocs/log_in_form/login_form_cubit.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EmailField(),
        AppSizes.gapH24,
        _PasswordField(),
        AppSizes.gapH48,
        _SignInButton(),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginState>(
      builder: (context, state) {
        return AppTextfield(
          hint: 'Enter Your Email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          errorText:
              state.email.displayError != null ? "Invalid email address" : null,
          onChange: (value) {
            context.read<LoginFormCubit>().emailChanged(value);
          },
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginState>(
      builder: (context, state) {
        return AppTextfield(
          hint: 'Enter Your Password',
          keyboardType: TextInputType.visiblePassword,
          obscureText: state.isObscure,
          suffixIcon: state.isObscure ? Icons.visibility_off : Icons.visibility,
          textInputAction: TextInputAction.done,
          errorText:
              state.password.displayError != null
                  ? "Password must be at least 8 characters"
                  : null,
          onSuffixIconTap: () {
            context.read<LoginFormCubit>().changeObscurity();
          },
          onChange: (value) {
            context.read<LoginFormCubit>().passwordChanged(value);
          },
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginFormCubit, LoginState>(
      builder: (context, loginState) {
        return BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, authState) {
            final isLoading = authState is AuthenticationLoadingState;
            final isEnabled = loginState.isValid && !isLoading;

            return AppButton(
              color: context.theme.primaryColor,
              width: 1.sw,
              title: 'Sign In',
              isLoading: isLoading,
              onClick:
                  isEnabled
                      ? () async {
                        FocusScope.of(context).unfocus();
                        await context
                            .read<AuthenticationCubit>()
                            .signInWithEmail(
                              loginState.email.value,
                              loginState.password.value,
                            );
                      }
                      : null,
            );
          },
        );
      },
    );
  }
}
