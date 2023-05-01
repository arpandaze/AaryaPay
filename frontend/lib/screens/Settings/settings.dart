import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/components/Wrapper.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/account_information.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection.dart';
import 'package:aaryapay/screens/Settings/Favourites/favourites_screen.dart';
import 'package:aaryapay/screens/Settings/Language/language_selection.dart';
import 'package:aaryapay/screens/Settings/Password/password_screen.dart';
import 'package:aaryapay/screens/Settings/Syncronization/syncronization_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<MenuModal> itemList = [
      MenuModal("Account", [
        MenuItemModal(
            onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const AccountInformation(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
            icon: SvgPicture.asset(
              "assets/icons/profile-line.svg",
              width: 20,
              height: 20,
            ),
            label: "Account Information",
            trailingWidget: const CustomArrowedButton()),
        MenuItemModal(
            onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const PasswordScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
            icon: SvgPicture.asset(
              "assets/icons/lock.svg",
              width: 20,
              height: 20,
            ),
            label: "Password & Security",
            trailingWidget: const CustomArrowedButton()),
        MenuItemModal(
            onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const FavouritesScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
            icon: SvgPicture.asset(
              "assets/icons/star.svg",
              width: 20,
              height: 20,
            ),
            label: "Favourites",
            trailingWidget: const CustomArrowedButton()),
      ]),
      MenuModal("General", [
        MenuItemModal(
            onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const SyncronizationScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
            icon: SvgPicture.asset(
              "assets/icons/sync.svg",
              width: 20,
              height: 20,
            ),
            label: "Synchronization",
            trailingWidget: const CustomArrowedButton()),
        MenuItemModal(
            onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const LanguageSelection(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
            icon: SvgPicture.asset(
              "assets/icons/language.svg",
              width: 20,
              height: 20,
            ),
            label: "Language",
            trailingWidget: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "English",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const CustomArrowedButton(),
                ],
              ),
            )),
      ]),
    ];

    return Wrapper(
      pageName: "settings",
      children: SizedBox(
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomMenuSelection(
                itemList: itemList,
              ),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: body(context),
    );
  }
}
