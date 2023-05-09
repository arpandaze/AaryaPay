import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Settings/Password/TwoFABloc/two_fa_bloc.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_third.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TwoFactorAuthSecond extends StatelessWidget {
  const TwoFactorAuthSecond({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<TwoFaBloc, TwoFaState>(
      listener: (context, state) {
        if (state.msgType == MessageType.error ||
            state.msgType == MessageType.success ||
            state.msgType == MessageType.warning) {
          SnackBarService.stopSnackBar();
          SnackBarService.showSnackBar(
              content: state.errorText, msgType: state.msgType);
        }
        if (state.success) {
          Utils.mainAppNav.currentState!.push(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const TwoFactorAuthThird(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
      builder: (context, state) {
        return SettingsWrapper(
          pageName: "Enter Verification Code",
          children: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height * 0.3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Text(
                    "Enter code",
                    style: Theme.of(context).textTheme.headlineMedium!.merge(
                          TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                  ),
                ),
                Text(
                  "Please enter the 6 digit code displayed by your Two Factor Authentication Application ",
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        const TextStyle(height: 1.5),
                      ),
                ),
                PinCodeTextField(
                  keyboardType: TextInputType.number,
                  length: 6,
                  hapticFeedbackTypes: HapticFeedbackTypes.light,
                  textStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  animationType: AnimationType.fade,
                  autoDismissKeyboard: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 65,
                    fieldWidth: 50,
                    inactiveColor: Theme.of(context).colorScheme.primary,
                    activeFillColor: Theme.of(context).colorScheme.background,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  onCompleted: (value) {
                    context.read<TwoFaBloc>().add(TokenChanged(token: value));
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
                Center(
                  child: CustomActionButton(
                    borderRadius: 10,
                    label: "Verify",
                    onClick: () =>
                        {context.read<TwoFaBloc>().add(EnableTwoFA())},
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      child: body(context),
    );
  }
}
