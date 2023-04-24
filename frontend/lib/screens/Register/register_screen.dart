import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Register/account_and_security.dart';
import 'package:aaryapay/screens/Register/components/register_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RegisterWrapper(
      backButton: true,
      backButttonFunction: () => {
        Navigator.pop(context),
      },
      title: "Identification",
      pageIndex: "1/3",
      actionButtonLabel: "Next",
      actionButtonFunction: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const AccountScreen(),
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
          prefixIcon: Container(
            child: SvgPicture.asset(
              "assets/icons/profile.svg",
              width: 20,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, BlendMode.srcIn),
            ), 
          ),
          // height: ,
          placeHolder: "First Name",
        ),
        CustomTextField(
          width: size.width,
          padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
          prefixIcon: Container(
            child: SvgPicture.asset(
              "assets/icons/blank.svg",
              width: 20,
            ), 
          ),
          // height: ,
          placeHolder: "Middle Name",
        ),
        CustomTextField(
          width: size.width,
          padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
          prefixIcon: Container(
            child: SvgPicture.asset(
              "assets/icons/blank.svg",
              width: 20,
            ), 
          ),
          // height: ,
          placeHolder: "Last Name",
        ),
      ],
    );
  }
}
