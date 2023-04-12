import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/screens/Settings/Password/change_password.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_first.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_third.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection_card.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: body(context, colorScheme, textTheme, size),
    );
  }

  bool switchValue = true;

  Widget body(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, Size size) {
    List<MenuModal> itemList = [
      MenuModal("Password", [
        MenuItemModal(
            onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ChangePassword(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
            icon: SvgPicture.asset(
              "assets/icons/profile-line.svg",
              width: 20,
              height: 20,
            ),
            label: "Change Password",
            trailingWidget: CustomArrowedButton()),
      ]),
      MenuModal("Additional Security", [
        MenuItemModal(
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  TwoFactorAuthFirst(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          ),
          icon: SvgPicture.asset(
            "assets/icons/profile-line.svg",
            width: 20,
            height: 20,
          ),
          label: "Enable 2FA",
          trailingWidget: CupertinoSwitch(
              value: switchValue,
              activeColor: colorScheme.outline,
              onChanged: (bool? value) {
                setState(() {
                  switchValue = !switchValue;
                });
              }),
        ),
      ]),
    ];

    return SettingsWrapper(
      pageName: "Password & Security",
      children: CustomMenuSelection(itemList: itemList),
    );
  }
}
