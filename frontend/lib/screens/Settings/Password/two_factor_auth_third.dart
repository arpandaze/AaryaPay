import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:aaryapay/screens/Settings/settings.dart';
import 'package:flutter/material.dart';

import '../../../components/CustomActionButton.dart';

class TwoFactorAuthThird extends StatelessWidget {
  const TwoFactorAuthThird({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return SettingsWrapper(
        pageName: "Successful",
        children: SizedBox(
          height: size.height,
          width: size.width * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.symmetric(vertical: 30),
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.cyanAccent)),
                  child: const CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/default-pfp.png"),
                    minRadius: 90,
                    maxRadius: 120,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      // width: 200,
                      child: Text(
                        "All Set to Go.",
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "Success!!! ",
                style: Theme.of(context).textTheme.headlineMedium!.merge(
                      TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary),
                    ),
              ),
              Text(
                "A few small taps for man, one giant leap for security!",
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                "You are ready for secure tranfers to come along",
                style: textTheme.bodySmall,
              ),
              Center(
                child: CustomActionButton(
                  label: "Done",
                  onClick: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const Settings(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
