import 'package:aaryapay/screens/Settings/Password/two_factor_auth_second.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TwoFactorAuthFirst extends StatelessWidget {
  const TwoFactorAuthFirst({Key? key}) : super(key: key);


  Widget body(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return SettingsWrapper(
        pageName: "Enable Two Factor Auth",
      children: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //replace with new generated qr
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const TwoFactorAuthSecond(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
              child: SvgPicture.asset(
                "assets/icons/qrcode.svg",
                width: 200,
                height: 200,
              ),
            ),
            Text(
              "Please Scan the Code",
              style: textTheme.headlineSmall!
                  .merge(const TextStyle(fontWeight: FontWeight.w700)),
            ),
            Text(
              "Scan QR Code with a 3rd Party Authenticator Application of your choice to Enable Two Factor Authentication",
              style: textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            Text("OR",
                style: textTheme.headlineSmall!
                    .merge(const TextStyle(fontWeight: FontWeight.w700))),
            Text(
              "Enter this code manually:(but where ?)",
              style: textTheme.titleSmall,
            ),
            Text("dytv9PNd47qc0yxBmIm1IuiJMnsk2DZRdLIw2yTo",
                style: textTheme.titleSmall!
                    .merge(const TextStyle(fontWeight: FontWeight.w700)))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    return Container(
      color: colorScheme.background,
      child: body(context),
    );
  }
}
