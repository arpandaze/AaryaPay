import 'package:aaryapay/screens/Settings/Syncronization/last_synchronized.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';

class SyncronizationScreen extends StatelessWidget {
  const SyncronizationScreen({Key? key}) : super(key: key);
  Widget body(BuildContext context, Size size) {
    return const SettingsWrapper(
      pageName: "Syncronization",
      children: LastSynchronized(),
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
