import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/repository/auth.dart';
import 'package:aaryapay/screens/Login/bloc/login_bloc.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Login/forgot_password.dart';
import 'package:aaryapay/screens/Login/login_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return RepositoryProvider<AuthenticationRepository>(
      create: (_) => AuthenticationRepository(),
      child: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.verificationStatus != current.verificationStatus,
          listener: (context, state) {
            if (state.verificationStatus == VerificationStatus.unverified) {
              SnackBarService.stopSnackBar();
              SnackBarService.showSnackBar(
                content: state.errorText,
              );
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const LoginVerifyScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }
            if (state.verificationStatus == VerificationStatus.error) {
              SnackBarService.stopSnackBar();
              SnackBarService.showSnackBar(
                content: state.errorText,
              );
            }
            if (state.loginSucess) {
              context.read<AuthenticationBloc>().add(LoggedIn());
            }
          },
          builder: (context, state) {
            return LoginWrapper(
              actionButtonLabel: "LOGIN",
              backButton: true,
              backButttonFunction: () => {
                Navigator.pop(context),
              },
              actionButtonFunction: () =>
                  context.read<LoginBloc>().add(LoginFormSubmitted()),
              children: _midsection(context, size),
            );
          },
        ),
      ),
    );
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Login",
          style: Theme.of(context).textTheme.headlineMedium!.merge(
                TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary),
              ),
        ),
        CustomTextField(
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginEmailChanged(value)),
          width: size.width,
          prefixIcon: Icon(
            FontAwesomeIcons.solidEnvelope,
            color: Theme.of(context).colorScheme.primary,
          ),
          // height: ,
          placeHolder: "E-mail Address",
        ),
        CustomTextField(
            onChanged: (value) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(value)),
            prefixIcon: Icon(
              FontAwesomeIcons.lock,
              color: Theme.of(context).colorScheme.primary,
            ),
          width: size.width,
          isPassword: true,
            placeHolder: "Password",
            counter: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                      TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary)),
              ),
              ),
              onTap: () => {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const ForgotPassword(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
              },
          ),
        ),
      ],
    );
  }
}
