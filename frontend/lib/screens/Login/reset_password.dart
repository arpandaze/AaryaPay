import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Login/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginWrapper(
        backButton: true,
        actionButtonLabel: "SUBMIT",
        backButttonFunction: () => {Navigator.pop(context)},
        actionButtonFunction: () => {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const OTPScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            },
        children: _midsection(context, size));
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            "Reset Password?",
            // overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.headlineMedium!.merge(
                  TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary),
                ),
          ),
        ),
        CustomTextField(
          prefixIcon: Icon(
            FontAwesomeIcons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
          width: size.width,
          suffixIcon: const Align(
            heightFactor: 1,
            widthFactor: 3,
            child: Icon(
              FontAwesomeIcons.eyeSlash,
              size: 20,
            ),
          ),

          // height: 1,
          // error: "Incorrect Password",
          isPassword: true,
          padding: const EdgeInsets.only(top: 20),
          placeHolder: "Password",
        ),
        CustomTextField(
          prefixIcon: Icon(
            FontAwesomeIcons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
          width: size.width,
          suffixIcon: const Align(
            heightFactor: 1,
            widthFactor: 3,
            child: Icon(
              FontAwesomeIcons.eyeSlash,
              size: 20,
            ),
          ),

          // height: 1,
          // error: "Incorrect Password",
          isPassword: true,
          padding: const EdgeInsets.only(top: 20),
          placeHolder: "Password",
        ),
      ],
    );
  }
}
