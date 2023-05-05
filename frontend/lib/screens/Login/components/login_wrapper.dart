import 'package:aaryapay/components/AuthenticationStatusWrapper.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aaryapay/screens/Login/bloc/login_bloc.dart';

class LoginWrapper extends StatelessWidget {
  const LoginWrapper(
      {Key? key,
      required this.children,
      this.backButton,
      this.backButttonFunction,
      this.actionButtonFunction,
      this.actionButtonLabel})
      : super(key: key);
  final Widget children;
  final bool? backButton;
  final String? actionButtonLabel;
  final Function()? backButttonFunction;
  final Function()? actionButtonFunction;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AuthenticationStateWrapper(
        child: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: body(size, context),
        ),
      ),
    );
  }

  Widget body(Size size, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.1,
                    // padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Visibility(
                        visible: backButton ?? false,
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: backButttonFunction,
                            child: const Icon(
                              FontAwesomeIcons.arrowLeftLong,
                              size: 20,
                            ))),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                  ),
                  Container(
                    width: size.width * 0.1,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(15),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: size.height * 0.3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage("assets/images/logo.png"),
              ),
            ),
          ),
          Container(
            height: size.height * 0.45,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: children,
          ),
          SizedBox(
            child: Column(
              children: [
                CustomActionButton(
                  width: size.width * 0.78,
                  borderRadius: 10,
                  label: actionButtonLabel,
                  onClick: actionButtonFunction,
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account, ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Text(
                            "Register",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .merge(TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ),
                          onTap: () => Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const RegisterScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
