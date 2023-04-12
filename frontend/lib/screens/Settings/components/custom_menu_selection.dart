import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomArrowedButton.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/account_information.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection_card.dart';
import 'package:aaryapay/screens/Settings/Favourites/favourites_screen.dart';
import 'package:aaryapay/screens/Settings/Language/language_selection.dart';
import 'package:aaryapay/screens/Settings/Password/password_screen.dart';
import 'package:aaryapay/screens/Settings/Syncronization/syncronization_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuItemModal {
  final Widget icon;
  final String label;
  final Widget trailingWidget;
  final Function()? onTap;

  const MenuItemModal( 
      {Key? key,
      required this.icon,
      required this.label,
      required this.trailingWidget,
      this.onTap});
}

class MenuModal {
  final String title;
  final List<MenuItemModal> menuItems;

  MenuModal(this.title, this.menuItems);
}

class CustomMenuSelection extends StatelessWidget {
  const CustomMenuSelection({Key? key, required this.itemList})
      : super(key: key);

  final List<MenuModal> itemList;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

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
                                onTap: subItem.onTap,
                              ))
                          .toList()
                    ],
                  ),
                ))
            .toList(),
      ]),
    );
  }
}
