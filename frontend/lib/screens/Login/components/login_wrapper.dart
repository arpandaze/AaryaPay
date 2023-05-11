import 'package:aaryapay/components/AuthenticationStatusWrapper.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Login/bloc/login_verify_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'dart:math' as math;

import 'package:jovial_svg/jovial_svg.dart';

class LoginWrapper extends StatelessWidget {
  const LoginWrapper({
    Key? key,
    required this.children,
    this.backButton,
    this.backButttonFunction,
    this.actionButtonFunction,
    this.actionButtonLabel,
    this.status,
  }) : super(key: key);
  final Widget children;
  final bool? backButton;
  final String? actionButtonLabel;
  final Function()? backButttonFunction;
  final Function()? actionButtonFunction;
  final LoginStatus? status;
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
                      onTap: () => Utils.mainAppNav.currentState!.pop(),
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
          SizedBox(height: size.height * 0.3, child: Utils.mainlogo),
          Container(
            height: size.height * 0.45,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: children,
          ),
          SizedBox(
            child: Column(
              children: [
                button(
                  context,
                  size,
                  actionButtonLabel,
                  actionButtonFunction,
                  status,
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
                          onTap: () => Utils.mainAppNav.currentState!
                              .pushNamed("/register"),
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

Widget button(BuildContext context, Size size, String? label,
    dynamic Function()? buttonFunc, LoginStatus? status) {
  if (status != LoginStatus.onprocess) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomActionButton(
          width: size.width * 0.78,
          borderRadius: 10,
          label: label,
          onClick: buttonFunc,
        ),
      ],
    );
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          child: const CircularProgressIndicator(),
        )
      ],
    );
  }
  ;
}
