import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/screens/Settings/Synchronization/last_synchronized.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricScreen extends StatelessWidget {
  const BiometricScreen({Key? key}) : super(key: key);

  Widget body(BuildContext context, Size size) {
    var _storage = FlutterSecureStorage();
    return SettingsWrapper(
      pageName: "Enable Biometric",
      children: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Enable Biometric",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            CupertinoSwitch(value: false, onChanged: (bool? value) {}),
          ],
        ),
      ),
    );
  }

  _onEnableBiometric() async {
    var _storage = FlutterSecureStorage();
    await _storage.write(key: "biometric", value: "true");

    SnackBarService.showSnackBar(content: "Biometric enabled");
  }

  Future<void> _onReadfromstoragee() async {
    var _storage = FlutterSecureStorage();
    String? biometric = await _storage.read(key: "biometric");
    print(biometric);
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
