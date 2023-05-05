import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/screens/Register/account_and_security.dart';
import 'package:aaryapay/screens/Register/bloc/register_bloc.dart';
import 'package:aaryapay/screens/Register/completed_screen.dart';
import 'package:aaryapay/screens/Register/identification.dart';
import 'package:aaryapay/screens/Register/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) => {
          if (state.msgType == MessageType.error ||
              state.msgType == MessageType.warning ||
              state.msgType == MessageType.success)
            {
              SnackBarService.stopSnackBar(),
              SnackBarService.showSnackBar(
                content: state.errorText,
                msgType: state.msgType,
              )
            },
        },
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () => onBackClicked(state.page, context),
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SafeArea(
                top: true,
                bottom: true,
                left: true,
                right: true,
                child: generatePage(state.page),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget generatePage(int page) {
    return Stack(
      children: [
        Visibility(
          child: Identification(),
          visible: page == 1,
          maintainState: true,
        ),
        Visibility(
          child: AccountScreen(),
          visible: page == 2,
          maintainState: true,
        ),
        Visibility(
          child: VerifyScreen(),
          visible: page == 3,
          maintainState: true,
        ),
        Visibility(
          child: CompletedScreen(),
          visible: page == 4,
          maintainState: true,
        ),
      ],
    );
  }

  Future<bool> onBackClicked(int page, BuildContext context) async {
    if (page <= 1 || page >= 4) {
      return true;
    } else {
      return false;
    }
  }
}
