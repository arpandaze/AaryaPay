import 'package:aaryapay/screens/Settings/components/settings_bottom_bar.dart';
import 'package:aaryapay/screens/Settings/components/settings_top_bar.dart';
import 'package:flutter/material.dart';

class SettingsWrapper extends StatelessWidget {
  const SettingsWrapper(
      {Key? key,
      required this.children,
      required this.pageName,
  })
      : super(key: key);

  final Widget children;
  final String pageName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      top: true,
      bottom: true,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Scaffold(
          bottomNavigationBar: const SettingsBottomBar(),
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: SettingsTopBar(
              label: pageName,
            ),
          ),
          body: children,
        ),
      ),
    );
  }
}
