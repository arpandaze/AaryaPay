import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Settings/Password/change_password.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_first.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  final bool switchValue = true;
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

  Widget body(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, Size size) {
    List<MenuModal> itemList = [
      MenuModal("Password", [
        MenuItemModal(
            onTap: () => Utils.mainAppNav.currentState!
                .pushNamed("/app/settings/password/change"),
            icon: SvgPicture.asset(
              "assets/icons/lock.svg",
              width: 20,
              height: 20,
            ),
            label: "Change Password",
            trailingWidget: const CustomArrowedButton()),
      ]),
      MenuModal("Additional Security", [
        MenuItemModal(
          onTap: () => Utils.mainAppNav.currentState!
              .pushNamed("/app/settings/password/twofa/first"),
          icon: SvgPicture.asset(
            "assets/icons/2fa.svg",
            width: 20,
            height: 20,
          ),
          label: "Enable 2FA",
          trailingWidget: CupertinoSwitch(
              value: switchValue,
              activeColor: colorScheme.surfaceVariant,
              onChanged: (bool? value) {}),
        ),
      ]),
    ];

    return SettingsWrapper(
      pageName: "Password & Security",
      children: Center(child: CustomMenuSelection(itemList: itemList)),
    );
  }
}
