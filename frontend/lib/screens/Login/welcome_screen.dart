import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return LoginWrapper(
      actionButtonLabel: "LOGIN",
      actionButtonFunction: () => {
        Utils.mainAppNav.currentState!.push(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const LoginScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        ),
      },
      children: _midSection(context, size),
    );
  }

  Widget _midSection(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
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
        Text(
          "Fast. Secure. Reliable.",
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .merge(const TextStyle(height: 3)),
          textAlign: TextAlign.center,
        ),
        Text(
          "Welcome to our app, where payments are a breeze and financial worries vanish. Join us on this journey to effortless transactions and hassle-free banking. Welcome aboard!",
          style: Theme.of(context).textTheme.titleMedium!.merge(
                const TextStyle(height: 1.5),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
