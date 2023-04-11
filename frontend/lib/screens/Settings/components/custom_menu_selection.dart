import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:aaryapay/screens/Settings/account_information.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection_card.dart';
import 'package:aaryapay/screens/Settings/favourites_screen.dart';
import 'package:aaryapay/screens/Settings/language_selection.dart';
import 'package:aaryapay/screens/Settings/password_screen.dart';
import 'package:aaryapay/screens/Settings/syncronization_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuItemModal {
  final Widget icon;
  final String label;
  final Widget trailingWidget;

  const MenuItemModal(
      {Key? key,
      required this.icon,
      required this.label,
      required this.trailingWidget});
}

class MenuModal {
  final String title;
  final List<MenuItemModal> menuItems;

  MenuModal(this.title, this.menuItems);
}

class CustomMenuSelection extends StatelessWidget {
  const CustomMenuSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    List<MenuModal> itemList = [
      MenuModal("Account", [
        MenuItemModal(
            icon: SvgPicture.asset(
              "assets/icons/profile-line.svg",
              width: 20,
              height: 20,
            ),
            label: "Account Information",
            trailingWidget: CustomArrowedButton(
              onPressed: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      AccountInformation(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            )),
        MenuItemModal(
            icon: SvgPicture.asset(
              "assets/icons/lock.svg",
              width: 20,
              height: 20,
            ),
            label: "Password & Security",
            trailingWidget: CustomArrowedButton(
              onPressed: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      PasswordScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            )),
        MenuItemModal(
            icon: SvgPicture.asset(
              "assets/icons/star.svg",
              width: 20,
              height: 20,
            ),
            label: "Favourites",
            trailingWidget: CustomArrowedButton(
              onPressed: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      FavouritesScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            )),
      ]),
      MenuModal("General", [
        MenuItemModal(
            icon: SvgPicture.asset(
              "assets/icons/sync.svg",
              width: 20,
              height: 20,
            ),
            label: "Synchronization",
            trailingWidget: CustomArrowedButton(
              onPressed: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      SyncronizationScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            )),
        MenuItemModal(
            icon: SvgPicture.asset(
              "assets/icons/language.svg",
              width: 20,
              height: 20,
            ),
            label: "Language",
            trailingWidget: SizedBox(
              width: 80,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "English",
                    style: textTheme.labelSmall,
                  ),
                  CustomArrowedButton(
                    onPressed: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            LanguageSelection(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ]),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Column(children: [
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
        CustomActionButton(
          label: "Logout",
          borderRadius: 10,
          width: size.width * 0.5,
          height: 45,
          onClick: () => Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const WelcomeScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          ),
        )
      ]),
    );
  }
}
