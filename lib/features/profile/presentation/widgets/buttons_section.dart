import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_todo_app/core/utils/extensions.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/route/app_router.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/blocs/authentication/authentication_cubit.dart';

class ButtonsSection extends StatelessWidget {
  final VoidCallback onSaveChanges;

  const ButtonsSection({super.key, required this.onSaveChanges});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Save button
        AppButton(
          color: context.theme.primaryColor,
          width: double.infinity,
          title: 'Save Changes',
          onClick: onSaveChanges,
        ),

        AppSizes.gapH16,

        // Logout button
        AppButton(
          color: Colors.red,
          width: double.infinity,
          title: 'Logout',
          onClick: () {
            context.read<AuthenticationCubit>().signout().then(
              (_) => context.goNamed(RouteNames.welcomepage),
            );
          },
        ),
      ],
    );
  }
}
