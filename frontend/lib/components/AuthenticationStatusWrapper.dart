import 'dart:async';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Login/login_two_fa_screen.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';

class AuthenticationStateWrapper extends StatelessWidget {
  final Widget child;
  const AuthenticationStateWrapper({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) => previous != current,
      listener: ((context, state) {
        print("Auth Status ${state.status}");
        if (state.status == AuthenticationStatus.loggedOut) {
          Timer(
            const Duration(microseconds: 0),
            () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const WelcomeScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          );
        }

        if (state.status == AuthenticationStatus.twoFA) {
          Timer(
            const Duration(microseconds: 0),
            () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const LoginTwoFA(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          );
        }
        if (state.status == AuthenticationStatus.loggedIn) {
          Timer(
            const Duration(microseconds: 0),
            () {
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const HomeScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (Route<dynamic> route) => false,
              );
            },
          );
        }
      }),
      builder: (context, state) {
        return child;
      },
    );
  }
}
