import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/core/utils/extensions.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/app_textfield.dart';
import '../../../../blocs/authentication/authentication_cubit.dart';
import '../../../../blocs/sign_up_form/sign_up_form_cubit.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UsernameField(),
        AppSizes.gapH12,
        _EmailField(),
        AppSizes.gapH12,
        _PasswordField(),
        AppSizes.gapH12,
        AppSizes.gapH48,
        _SignUpButton(),
      ],
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField();

  @override
  Widget build(BuildContext context) {
    final error = context.select(
      (SignUpFormCubit cubit) => cubit.state.username.displayError,
    );
    return AppTextfield(
      hint: 'Enter Your Username',
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      onChange: (value) {
        context.read<SignUpFormCubit>().usernameChanged(value);
      },
      errorText:
          error != null ? "Username must be at least 3 characters" : null,
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final error = context.select(
      (SignUpFormCubit cubit) => cubit.state.email.displayError,
    );
    return AppTextfield(
      hint: 'Enter Your Email',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChange: (value) {
        context.read<SignUpFormCubit>().emailChanged(value);
      },
      errorText: error != null ? "Enter a valid email" : null,
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final error = context.select(
      (SignUpFormCubit cubit) => cubit.state.password.displayError,
    );
    return BlocBuilder<SignUpFormCubit, SignUpState>(
      builder: (context, state) {
        return AppTextfield(
          hint: 'Enter Your Password',
          keyboardType: TextInputType.visiblePassword,
          obscureText: state.isPasswordObscure,
          textInputAction: TextInputAction.done,
          suffixIcon:
              state.isPasswordObscure ? Icons.visibility_off : Icons.visibility,
          onSuffixIconTap: () {
            context.read<SignUpFormCubit>().changePasswordObscurity();
          },
          onChange: (value) {
            context.read<SignUpFormCubit>().passwordChanged(value);
          },
          errorText:
              error != null ? "Password must be at least 8 characters" : null,
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context.select(
      (SignUpFormCubit cubit) => cubit.state.isValid,
    );

    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        final isLoading = state is AuthenticationLoadingState;
        return AppButton(
          color: context.theme.primaryColor,
          width: 1.sw,
          title: 'Sign Up',
          isLoading: isLoading,
          onClick:
              (isEnabled && !isLoading)
                  ? () {
                    FocusScope.of(context).unfocus();
                    context.read<AuthenticationCubit>().signUp(
                      context.read<SignUpFormCubit>().state.email.value,
                      context.read<SignUpFormCubit>().state.password.value,
                      context.read<SignUpFormCubit>().state.username.value,
                    );
                  }
                  : null,
        );
      },
    );
  }
}
