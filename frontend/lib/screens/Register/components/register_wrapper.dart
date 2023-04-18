
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aaryapay/components/CustomActionButton.dart';

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
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.09,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerLeft,
                    child: Visibility(
                        visible: backButton ?? false,
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: backButttonFunction,
                            child: const Icon(FontAwesomeIcons.arrowLeftLong))),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Text("Send Money",
                        style: Theme.of(context).textTheme.headlineMedium!),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(top: 20),
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/pfp.jpeg"),
              minRadius: 70,
              maxRadius: 100,
            )),
        Container(
            height: size.height * 0.5,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: children),
        CustomActionButton(
          label: actionButtonLabel,
          onClick: actionButtonFunction,
        ),
      ],
    );
  }
}
