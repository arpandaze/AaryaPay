import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Login/forgot_password.dart';
import 'package:aaryapay/screens/Login/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import "package:aaryapay/screens/Login/welcome_screen.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginWrapper(
      children: _midsection(context, size),
      backButton: false,
      backButttonFunction: () => {
        Navigator.pop(context),
      },
      actionButtonFunction: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomeScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ),
    );
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          style: Theme.of(context).textTheme.headlineMedium!.merge(
                TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary),
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
        CustomTextField(
            prefixIcon: Icon(
              FontAwesomeIcons.lock,
              color: Theme.of(context).colorScheme.primary,
            ),
            width: size.width,
      

            // height: 1,
            // error: "Incorrect Password",
            isPassword: true,
            padding: EdgeInsets.only(top: 20),
            placeHolder: "Password",
            counter: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: (Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.bodySmall!.merge(TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary)),
                )),
              ),
              onTap: () => {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ForgotPassword(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
              },
            )),
      ],
    );
  }
}
