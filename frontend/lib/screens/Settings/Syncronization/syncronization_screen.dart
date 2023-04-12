import 'package:aaryapay/screens/Settings/Syncronization/last_synchronized.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';

class SyncronizationScreen extends StatelessWidget {
  const SyncronizationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return SettingsWrapper(
      pageName: "Syncronization",
      children: LastSynchronized(),
    );
  }
}
