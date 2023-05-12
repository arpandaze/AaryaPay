import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Login/bloc/forgot_bloc.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Login/reset_password.dart';
import 'package:aaryapay/screens/Register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ForgotBloc(),
      child: BlocConsumer<ForgotBloc, ForgotState>(
        listener: (context, state) {
          if (state.status == ForgotStatus.error) {
            SnackBarService.stopSnackBar();
            SnackBarService.showSnackBar(
              content: state.errorText,
            );
          }
          if (state.status == ForgotStatus.success && state.userid != null) {
            Utils.mainAppNav.currentState!.push(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    ResetPassword(userid: state.userid),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        builder: (context, state) {
          return LoginWrapper(
            forgotStatus: state.status,
            backButton: true,
            actionButtonLabel: "Submit",
            backButttonFunction: () =>
                {Utils.mainAppNav.currentState!.pop(context)},
            actionButtonFunction: () => {
              context.read<ForgotBloc>().add(
                    SendEmail(),
                  ),
              //
            },
            children: _midsection(context, size),
          );
        },
      ),
    );
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Text(
            "Forgot Password?",
            style: Theme.of(context).textTheme.headlineMedium!.merge(
                  TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary),
                ),
          ),
        ),
        Text(
          "Don’t worry it happens! Please enter the email associated with your account.",
          style: Theme.of(context).textTheme.titleMedium!.merge(
                const TextStyle(height: 1.5),
              ),
        ),
        CustomTextField(
          onChanged: (value) =>
              context.read<ForgotBloc>().add(ForgotEmailChanged(email: value)),
          padding: const EdgeInsets.only(top: 20),
          width: size.width,
          prefixIcon: Icon(
            FontAwesomeIcons.solidEnvelope,
            color: Theme.of(context).colorScheme.primary,
          ),
          // height: ,
          placeHolder: "E-mail Address",
        ),
      ],
    );
  }
}
