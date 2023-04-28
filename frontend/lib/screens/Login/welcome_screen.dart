import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginWrapper(
      children: _midSection(context, size),
      actionButtonFunction: () => {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const LoginScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        ),
      },
    );
  }

  Widget _midSection(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size.width * 0.8,
          child: Text(
            "Pay Anywhere, You Go.",
            style: Theme.of(context).textTheme.displayMedium!.merge(TextStyle(
                height: 1.8,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          child: Text(
            "Fast. Secure. Reliable.",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .merge(const TextStyle(height: 3)),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          child: Text(
            "Does anyone even read this text. No. Why are you reading this text. Just login already, this text is worthless.",
            style: Theme.of(context).textTheme.titleMedium!.merge(
                  const TextStyle(height: 1.5),
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
