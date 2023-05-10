import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:aaryapay/screens/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountInformation extends StatelessWidget {
  const AccountInformation({Key? key}) : super(key: key);

  Widget body(Size size, ColorScheme colorScheme, BuildContext context) {
    return SettingsWrapper(
      pageName: "Account Information",
      children: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                      image:
                                AssetImage("assets/images/default-pfp.png"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomStatusButton(
                      width: 150,
                      borderRadius: 5,
                      widget: SvgPicture.asset(
                        "assets/icons/upload.svg",
                        width: 18,
                        height: 18,
                      ),
                      label: "Upload Photo"),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: CustomTextField(
                outlined: true,
                topText: "First Name",
                enableTopText: true,
                placeHolder: "Mukesh",
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: CustomTextField(
                outlined: true,
                topText: "Middle Name",
                enableTopText: true,
                placeHolder: "Kumar",
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: CustomTextField(
                outlined: true,
                topText: "Last Name",
                enableTopText: true,
                placeHolder: "Ambani",
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: CustomTextField(
                outlined: true,
                topText: "Email",
                enableTopText: true,
                placeHolder: "mukesh@ambani.com",
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: CustomTextField(
                outlined: true,
                topText: "Date of Birth",
                enableTopText: true,
                placeHolder: "Date of Birth",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CustomActionButton(
                label: "Save",
                borderRadius: 10,
                width: size.width * 0.78,
                onClick: () => Utils.mainAppNav.currentState!.push(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Container(
      color: colorScheme.background,
      child: body(size, colorScheme, context),
    );
  }
}
