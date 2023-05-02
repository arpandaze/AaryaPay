import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/repository/change_password.dart';
import 'package:aaryapay/screens/Settings/Password/bloc/password_bloc.dart';
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
    return BlocBuilder<PasswordBloc, PasswordState>(
      buildWhen: ((previous, current) => previous != current),
      builder: (context, state) {
        return SettingsWrapper(
          pageName: "Change Password",
          children: Center(
            child: Column(
              children: [
                SizedBox(
                  width: size.width * 0.9,
                  // height: size.height,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
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
                          padding: EdgeInsets.all(8.0),
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
                          padding: EdgeInsets.all(8.0),
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget button(BuildContext context, Size size) {
    return BlocBuilder<PasswordBloc, PasswordState>(
      builder: (context, state) {
        if (state.status != PasswordChangeStatus.submitting) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomActionButton(
                  label: "Save",
                  width: size.width * 0.5,
                  height: 50,
                  borderRadius: 10,
                  onClick: () {
                    context.read<PasswordBloc>().add(SubmitEvent());
                    final snackBar = SnackBar(content: errorText(state.status), backgroundColor: Colors.green);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    if (state.status == PasswordChangeStatus.success) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.fromLTRB(
                    0, 0, size.width * 0.1, size.height * 0.05),
                child: const CircularProgressIndicator(),
              )
            ],
          );
        }
      },
    );
  }

  Widget errorText(PasswordChangeStatus state) {
    switch (state) {
      case PasswordChangeStatus.empty:
        return const Text("Fields cannot be empty");
      case PasswordChangeStatus.mismatch:
        return const Text("Passwords mismatch");
      case PasswordChangeStatus.success:
        return const Text("Password changed successfully");
      case PasswordChangeStatus.error:
        return const Text("Error Changing Password");
      default:
        return const Text("Something went wrong! Check your inputs");
    }
  }
}
