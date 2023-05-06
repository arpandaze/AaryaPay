import 'package:aaryapay/components/AuthenticationStatusWrapper.dart';
import 'package:aaryapay/screens/Register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'dart:math' as math;

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
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Visibility(
                    visible: backButton ?? false,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Transform.rotate(
                          angle: -math.pi,
                          child: SvgPicture.asset(
                            "assets/icons/arrow2.svg",
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
