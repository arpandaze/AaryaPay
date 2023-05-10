import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:flutter/material.dart';

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
          Container(
            height: size.height * 0.3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage("assets/images/logo.png"),
              ),
            ),
          ),
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
                        "Does anyone even read this text. No. Why are you reading this text. Just login already, this text is worthless.",
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
          Container(
            child: CustomActionButton(
              width: size.width * 0.78,
              borderRadius: 10,
              label: "Done",
              onClick: () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const LoginScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
