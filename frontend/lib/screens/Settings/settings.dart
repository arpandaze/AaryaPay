import 'package:aaryapay/components/Wrapper.dart';
import 'package:aaryapay/screens/Settings/components/custom_menu_selection.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Wrapper(
      pageName: "settings",
      children: Container(
        child: CustomMenuSelection(),
      ),
    );
  }
}
