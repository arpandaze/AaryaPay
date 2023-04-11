import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/screens/Settings/change_password.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection_card.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({Key? key}) : super(key: key);

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
            icon: SvgPicture.asset(
              "assets/icons/profile-line.svg",
              width: 20,
              height: 20,
            ),
            label: "Change Password",
            trailingWidget: CustomArrowedButton(
              onPressed: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ChangePassword(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            )),
      ]),
      MenuModal("Additional Security", [
        MenuItemModal(
          icon: SvgPicture.asset(
            "assets/icons/profile-line.svg",
            width: 20,
            height: 20,
          ),
          label: "Enable 2FA",
          trailingWidget: CupertinoSwitch(
              value: true,
              // This bool value toggles the switch.
              activeColor: colorScheme.outline,
              onChanged: (bool? value) {
                // This is called when the user toggles the switch.
                print("lol");
              }),
        ),
      ]),
    ];

    return SettingsWrapper(
        backButtonFunction: () => Navigator.pop(context),
        pageName: "Password & Security",
        children: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ...itemList
                .map((item) => Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: textTheme.titleMedium,
                          ),
                          ...item.menuItems
                              .map((subItem) => CustomMenuSelectionCard(
                                    icon: subItem.icon,
                                    label: subItem.label,
                                    trailingWidget: subItem.trailingWidget,
                                  ))
                              .toList()
                        ],
                      ),
                    ))
                .toList(),
          ],
        ));
  }
}
