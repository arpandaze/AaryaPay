import 'dart:ffi' as ffi;

import 'package:aaryapay/components/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import "package:aaryapay/screens/Login/welcome_screen.dart";

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
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: body(size, context),
        ));
  }

  Widget body(Size size, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: size.height,
      // decoration: BoxDecoration(
      //     border: Border.all(color: Color.fromARGB(255, 250, 0, 0), width: 5)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.cyanAccent)),
              height: size.height * 0.4,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.symmetric(vertical: 30),
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.cyanAccent)),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/pfp.jpeg"),
                        minRadius: 90,
                        maxRadius: 120,
                      )),
                  Visibility(
                    visible: backButton ?? false,
                    child: Positioned(
                        top: 30,
                        left: 10,
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: backButttonFunction,
                            child: Container(
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: Colors.deepPurple)),
                                width: 30,
                                height: 30,
                                child: Icon(FontAwesomeIcons.arrowLeftLong)))),
                  ),
                ],
              ),
            ),
            Container(
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.cyanAccent)),
                height: size.height * 0.35,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: children),
            Container(
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.cyanAccent)),
              height: size.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomActionButton(
                    label: actionButtonLabel,
                    onClick: actionButtonFunction,
                  ),
                  Container(
                    height: 30,
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account, ",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Text(
                                "Register",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .merge(TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary)),
                              ),
                              onTap: () => print("lol"))
                        ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
