import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Register/components/register_wrapper.dart';
import 'package:aaryapay/screens/Register/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RegisterWrapper(
      backButton: true,
      backButttonFunction: () => {
        Navigator.pop(context),
      },
      title: "Account and Security",
      pageIndex: "2/3",
      actionButtonLabel: "Next",
      actionButtonFunction: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const VerifyScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ),
      children: _midsection(context, size),
    );
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sign Up",
              style: Theme.of(context).textTheme.displaySmall!.merge(
                    TextStyle(
                        height: 1.8,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary),
                  ),
            ),
            Text(
              "Fill the form to Sign Up for AaryaPay. Pay Anywhere, You Go",
              style: Theme.of(context).textTheme.titleSmall!.merge(
                    TextStyle(
                        height: 2,
                        // fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary),
                  ),
            ),
          ],
        ),
        CustomTextField(
          width: size.width,
          padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
          prefixIcon: Icon(
            FontAwesomeIcons.solidEnvelope,
            color: Theme.of(context).colorScheme.primary,
          ),
          // height: ,
          placeHolder: "Email",
        ),
        CustomTextField(
          width: size.width,
          padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
          prefixIcon: Container(
            child: SvgPicture.asset(
              "assets/icons/calendar.svg",
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, BlendMode.srcIn),
              width: 25,
            ),
          ),
          // height: ,
          placeHolder: "Date of Birth",
        ),
        CustomTextField(
          width: size.width,
          isPassword: true,
          padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
          prefixIcon: Icon(
            FontAwesomeIcons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
          // height: ,
          placeHolder: "Password",
        ),
      ],
    );
  }
}
