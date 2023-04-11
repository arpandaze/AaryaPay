import 'package:flutter/material.dart';

class SettingsBottomBar extends StatelessWidget {
  const SettingsBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.07,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colorScheme.onPrimary))),
      child: Text("© AaryaPay 2023"),
    );
  }
}
