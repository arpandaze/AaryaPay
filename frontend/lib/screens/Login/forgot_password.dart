import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Login/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginWrapper(
      children: _midsection(context, size),
      backButton: true,
      actionButtonLabel: "SUBMIT",
      backButttonFunction: () => {Navigator.pop(context)},
      actionButtonFunction: () => {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ResetPassword(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        ),
      },
    );
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          child: Text(
            "Forgot Password?",
            style: Theme.of(context).textTheme.headlineMedium!.merge(
                  TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.secondary),
                ),
          ),
        ),
        Text(
          "Does anyone even read this text. Why are you reading this text. Just login already, thistext is worthless. ?",
          style: Theme.of(context).textTheme.bodySmall!.merge(
                TextStyle(
                    // fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary),
              ),
        ),
        CustomTextField(
          padding: EdgeInsets.only(top: 20),
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