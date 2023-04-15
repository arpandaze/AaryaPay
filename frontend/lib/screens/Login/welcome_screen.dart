import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginWrapper(
      children: _midSection(context),
      actionButtonFunction: () => {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const LoginScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        ),
      },
    );
  }

  Widget _midSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Pay Anywhere, You Go.",
              style: Theme.of(context).textTheme.displaySmall!.merge(TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
            ),
            Text(
              "Fast. Secure. Reliable.",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .merge(const TextStyle(height: 2)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Does anyone even read this text. No. Why are you reading this text. Just login already, this text is worthless.",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .merge(const TextStyle(height: 1.5)),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
