import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/screens/Login/bloc/login_verify_bloc.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:aaryapay/screens/Register/completed_screen.dart';
import 'package:aaryapay/screens/Login/components/register_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginVerifyScreen extends StatelessWidget {
  const LoginVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LoginVerifyBloc(),
      child: BlocConsumer<LoginVerifyBloc, LoginVerifyState>(
        listener: (context, state) => {
          // if (state.status != LoginVerifyStatus.completed)
          //   {
          //
          //     SnackBarService.showSnackBar(
          //         content: "Please enter the verification token")
          //   },
          if (state.status == LoginVerifyStatus.error)
            {
              SnackBarService.stopSnackBar(),
              SnackBarService.showSnackBar(content: state.errorText, msgType: MessageType.error)
            },
          if (state.status == LoginVerifyStatus.verified)
            {
              SnackBarService.stopSnackBar(),
              SnackBarService.showSnackBar(content: state.errorText, msgType: MessageType.success),
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const LoginScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (Route<dynamic> route) => false,
              ),
            }
        },
        builder: (context, state) => RegisterWrapper(
          backButton: true,
          backButttonFunction: () => {
            Navigator.pop(context),
          },
          title: "Verify your account",
          actionButtonLabel: "Next",
          actionButtonFunction: () =>
              context.read<LoginVerifyBloc>().add(VerifyFormSubmitted()),
          children: _midsection(context, size),
        ),
      ),
    );
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Verify Your Account",
              style: Theme.of(context).textTheme.displaySmall!.merge(
                    TextStyle(
                        height: 1.8,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary),
                  ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please enter the 6 digit code sent from AARYAPAY",
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        TextStyle(
                            height: 1.8,
                            // fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 40),
          child: PinCodeTextField(
            keyboardType: TextInputType.number,
            length: 6,
            hapticFeedbackTypes: HapticFeedbackTypes.light,
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.onBackground),
            // obscureText: true,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 65,
              fieldWidth: 50,
              inactiveColor: Theme.of(context).colorScheme.primary,
              activeFillColor: Colors.white,
            ),
            // activeColor: Theme.of(context).colorScheme.secondary),
            animationDuration: const Duration(milliseconds: 300),
            onCompleted: (value) {
              context
                  .read<LoginVerifyBloc>()
                  .add(VerifyTokenChanged(value, true));
            },
            onChanged: (value) {},
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              return true;
            },
            appContext: context,
          ),
        ),
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Didn't Receive Code?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Resend Code",
                  style: Theme.of(context).textTheme.bodyMedium!.merge(
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
                ),
              ),
              onTap: () => context
                  .read<LoginVerifyBloc>()
                  .add(ResendVerificationEmail()),
            )
          ]),
        ),
      ],
    );
  }
}
