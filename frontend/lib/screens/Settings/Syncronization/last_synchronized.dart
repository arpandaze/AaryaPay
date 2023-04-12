import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Login/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LastSynchronized extends StatelessWidget {
  const LastSynchronized({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      // height: size.height * 0.14,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Last Synchronization",
                    style: textTheme.titleMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Text(
                      "12/04/2023   5:45 pm",
                      style: textTheme.titleSmall!
                          .merge(TextStyle(color: colorScheme.surface)),
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomStatusButton(
                      widget: SvgPicture.asset(
                        "assets/icons/sync.svg",
                        height: 11,
                        width: 11,
                      ),
                      label: "Sync"),
                  Container(
                      width: size.width * 0.18,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Pending",
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall!.merge(
                          TextStyle(color: colorScheme.background),
                        ),
                      )),
                ],
              )
            ]),
      ),
    );
  }
}
