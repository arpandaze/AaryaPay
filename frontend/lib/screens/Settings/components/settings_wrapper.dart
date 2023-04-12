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
        width: double.infinity,
        height: size.height,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topLeft,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SettingsTopBar(
                  label: pageName,
                ),
                Flexible(child: children),
                const Positioned(
                  bottom: 0,
                  child: SettingsBottomBar(),
                )
              ],
            ),
        
          ],
        ),
      ),
    );
  }
}
