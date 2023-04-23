import 'package:aaryapay/screens/Settings/components/custom_menu_selection_card.dart';
import 'package:flutter/material.dart';

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
                        style: Theme.of(context).textTheme.titleMedium,
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
