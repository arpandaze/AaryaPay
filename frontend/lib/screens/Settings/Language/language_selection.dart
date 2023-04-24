import 'package:aaryapay/screens/Settings/components/custom_menu_selection.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({Key? key}) : super(key: key);

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String currentLanguage = "english";

  Widget body(BuildContext context, Size size) {
    List<MenuModal> itemList = [
      MenuModal("Select a Language", [
        MenuItemModal(
          onTap: () => setState(() {
            currentLanguage = "english";
          }),
          icon: SvgPicture.asset(
            currentLanguage == "english"
                ? "assets/icons/us-flag-color.svg"
                : "assets/icons/us-flag-color.svg",
            width: 20,
            height: 20,
          ),
          label: "English",
          trailingWidget: Visibility(
            visible: currentLanguage == "english",
            child: SvgPicture.asset(
              "assets/icons/check.svg",
              width: 15,
              height: 15,
            ),
          ),
        ),
        MenuItemModal(
          onTap: () => setState(() {
            currentLanguage = "nepali";
          }),
          icon: SvgPicture.asset(
            currentLanguage == "nepali"
                ? "assets/icons/nepal-flag-color.svg"
                : "assets/icons/nepal-flag.svg",
            width: 20,
            height: 20,
          ),
          label: "Nepali",
          trailingWidget: Visibility(
            visible: currentLanguage == "nepali",
            child: SvgPicture.asset(
              "assets/icons/check.svg",
              width: 15,
              height: 15,
            ),
          ),
        ),
      ]),
    ];

    return SettingsWrapper(
        pageName: "Language",
      children: Center(child: CustomMenuSelection(itemList: itemList)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Container(
      color: colorScheme.background,
      child: body(context, size),
    );
  }


}
