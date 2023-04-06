import 'dart:ffi' as ffi;

import 'package:aaryapay/components/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import "package:aaryapay/screens/Login/welcome_screen.dart";

class RegisterWrapper extends StatelessWidget {
  const RegisterWrapper(
      {Key? key,
      required this.children,
      this.backButton,
      this.title,
      this.backButttonFunction,
      this.actionButtonFunction,
      this.actionButtonLabel})
      : super(key: key);
  final Widget children;
  final bool? backButton;
  final String? title;
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
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: size.height,
      // decoration: BoxDecoration(
      //     border: Border.all(color: Color.fromARGB(255, 250, 0, 0), width: 5)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.35,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      title ?? "",
                      style: Theme.of(context).textTheme.titleMedium!.merge(
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary)),
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.deepPurple)),
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/pfp.jpeg"),
                        minRadius: 70,
                        maxRadius: 100,
                      )),
                  Visibility(
                    visible: backButton ?? false,
                    child: Positioned(
                        top: 10,
                        left: 15,
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: backButttonFunction,
                            child: const SizedBox(
                                child: Icon(FontAwesomeIcons.arrowLeftLong)))),
                  ),
                ],
              ),
            ),
            Container(
                height: size.height * 0.5,
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.cyanAccent)),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: children),

            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.cyanAccent)),
            CustomActionButton(
              label: actionButtonLabel,
              onClick: actionButtonFunction,
            ),
          ],
        ),
      ),
    );
  }
}
