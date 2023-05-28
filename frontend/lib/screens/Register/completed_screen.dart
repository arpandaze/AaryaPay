import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
            child: Container(),
          ),
          SizedBox(height: size.height * 0.3, child: Utils.mainlogo),
          Container(
            height: size.height * 0.48,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "You Are, All Set",
                      style: Theme.of(context).textTheme.displayMedium!.merge(
                            TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "Congratulations! You've cracked the code and gained access to a world of smooth transactions and digital enchantment. Get ready for a magical journey! Welcome aboard!",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .merge(const TextStyle(height: 2.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomActionButton(
              width: size.width * 0.78,
              borderRadius: 10,
              label: "Done",
              onClick: () =>
                  Utils.mainAppNav.currentState!.pushReplacementNamed("/login"),
            ),
          ),
        ],
      ),
    );
  }
}
