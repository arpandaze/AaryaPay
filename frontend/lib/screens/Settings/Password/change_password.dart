import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/repository/change_password.dart';
import 'package:aaryapay/screens/Settings/Password/PasswordBloc/password_bloc.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => PasswordBloc(
          context: context,
          passwordRepository: PasswordRepository(
              token: context.read<AuthenticationBloc>().state.token)),
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: body(context, colorScheme, textTheme, size),
      ),
    );
  }

  Widget body(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, Size size) {
    return BlocConsumer<PasswordBloc, PasswordState>(
      listener: (context, state) => {
        if (state.msgType == MessageType.error ||
            state.msgType == MessageType.warning ||
            state.msgType == MessageType.success)
          {
            SnackBarService.stopSnackBar(),
            SnackBarService.showSnackBar(
              content: state.errorText,
              msgType: state.msgType,
            )
          },
        if (state.msgType == MessageType.success) {Navigator.of(context).pop()}
      },
      buildWhen: ((previous, current) => previous != current),
      builder: (context, state) {
        return SettingsWrapper(
          pageName: "Change Password",
          children: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  outlined: true,
                  placeHolder: "Current Password",
                  isPassword: true,
                  onChanged: (value) => context
                      .read<PasswordBloc>()
                      .add(CurrentChanged(currentPassword: value)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Passwords must have 8 characters and include an alphabet, a number, and a special character"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  isPassword: true,
                  outlined: true,
                  placeHolder: "New Password",
                  onChanged: (value) => context
                      .read<PasswordBloc>()
                      .add(NewChanged(newPassword: value)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  isPassword: true,
                  outlined: true,
                  placeHolder: "Confirm New Password",
                  onChanged: (value) => context
                      .read<PasswordBloc>()
                      .add(ConfirmChanged(confirmPassword: value)),
                ),
              ),
              button(context, size),
            ]),
          ),
        );
      },
    );
  }

  Widget button(BuildContext context, Size size) {
    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: ((previous, current) => previous != current),
      builder: (context, state) {
        if (!state.submitStatus) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomActionButton(
              label: "Save",
              width: size.width * 0.6,
              height: 50,
              borderRadius: 10,
              onClick: () {
                context.read<PasswordBloc>().add(SubmitEvent());
              },
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.all(15),
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
