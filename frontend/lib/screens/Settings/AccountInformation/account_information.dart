import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomDatePicker.dart';
import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:aaryapay/screens/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class AccountInformation extends StatelessWidget {
  const AccountInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: body(size, colorScheme, context),
    );
  }

  Widget body(Size size, ColorScheme colorScheme, BuildContext context) {
    return SettingsWrapper(
      pageName: "Account Information",
      children: Expanded(
        child: SingleChildScrollView(
          child: Container(
            width: size.width * 0.9,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/pfp.jpeg")))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomStatusButton(
                            width: 100,
                            borderRadius: 5,
                            widget: SvgPicture.asset(
                              "assets/icons/upload.svg",
                              width: 15,
                              height: 15,
                            ),
                            label: "Upload"),
                      )
                    ],
                  ),
                  CustomTextField(
                    outlined: true,
                    topText: "First Name",
                    enableTopText: true,
                    placeHolder: "Mukesh",
                  ),
                  CustomTextField(
                    outlined: true,
                    topText: "Middle Name",
                    enableTopText: true,
                    placeHolder: "gau",
                  ),
                  CustomTextField(
                    outlined: true,
                    topText: "Last Name",
                    enableTopText: true,
                    placeHolder: "Ambani",
                  ),
                  CustomTextField(
                    outlined: true,
                    topText: "Email",
                    enableTopText: true,
                    placeHolder: "mukesh@india.com",
                  ),

                  CustomTextField(
                    outlined: true,
                    topText: "Date",
                    enableTopText: true,
                    placeHolder: "new date field needed pls fix",
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomActionButton(
                      label: "Save",
                      borderRadius: 10,
                      width: size.width * 0.5,
                      height: 45,
                      onClick: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const Settings(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      ),
                    ),
                  )

                  // CustomDateButton(onChangeVal: ())
                ]),
          ),
        ),
      ),
    );
  }
}
