import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: body(context, colorScheme, textTheme, size),
    );
  }

  Widget body(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, Size size) {
    return SettingsWrapper(
      pageName: "Change Password",
      children: Column(
        children: [
          SizedBox(
            width: size.width * 0.9,
            // height: size.height,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomTextField(
                  outlined: true,
                  placeHolder: "Current Password",
                  isPassword: true,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    "Passwords must have 8 characters and include an alphabet, a number, and a special character"),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomTextField(
                  isPassword: true,
                  outlined: true,
                  placeHolder: "New Password",
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomTextField(
                  isPassword: true,
                  outlined: true,
                  placeHolder: "Confirm New Password",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomActionButton(
                  label: "Save",
                  width: size.width * 0.5,
                  height: 50,
                  borderRadius: 10,
                  onClick: () => Navigator.pop(context),
                ),
              ),
              // Expanded(
              //   child: Container(),
              // ),
            ]),
          ),
        ],
      ),
    );
  }
}
