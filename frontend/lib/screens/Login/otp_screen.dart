import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Login/bloc/forgot_bloc.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({Key? key, this.password, this.userid}) : super(key: key);
  final String? userid;
  final String? password;
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
          if (state.status == ForgotStatus.otpSuccess) {
            Utils.mainAppNav.currentState!.push(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const WelcomeScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          return LoginWrapper(
            forgotStatus: state.status,
            backButton: true,
            actionButtonLabel: "Submit",
            backButttonFunction: () => {Navigator.pop(context)},
            actionButtonFunction: () => {
              context.read<ForgotBloc>().add(
                    SubmitOTP(userid: userid, password: password),
                  )
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
          width: 200,
          child: Text(
            "Enter OTP",
            style: Theme.of(context).textTheme.headlineMedium!.merge(
                  TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary),
                ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please enter the 6 digit code sent to: ",
              style: Theme.of(context).textTheme.bodySmall!.merge(
                    TextStyle(
                        // fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary),
                  ),
            ),
            Text(
              "aaryapay@aaryapay.com",
              style: Theme.of(context).textTheme.bodySmall!.merge(
                    TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary),
                  ),
            ),
          ],
        ),
        PinCodeTextField(
          keyboardType: TextInputType.number,
          length: 6,
          hapticFeedbackTypes: HapticFeedbackTypes.light,
          textStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          // obscureText: true,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 65,
            fieldWidth: 50,
            inactiveColor: Theme.of(context).colorScheme.primary,
            activeFillColor: Theme.of(context).colorScheme.background,
          ),
          // activeColor: Theme.of(context).colorScheme.secondary),
          animationDuration: const Duration(milliseconds: 300),
          // backgroundColor: Colors.blue.shade50,
          // enableActiveFill: true,
          // errorAnimationController: errorController.add(ErrorAnimationType.shake);,
          // controller: textEditingController,
          onCompleted: (value) {
            context.read<ForgotBloc>().add(TokenChanged(otpToken: value));
          },
          onChanged: (value) {
            // setState(() {
            //   currentText = value;
            // });
          },
          beforeTextPaste: (text) {
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
          appContext: context,
        )
      ],
    );
  }
}
