import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/screens/Settings/Password/two_factor_auth_third.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TwoFactorAuthSecond extends StatelessWidget {
  const TwoFactorAuthSecond({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return SettingsWrapper(
      pageName: "Enter Verification Code",
      children: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              // padding: EdgeInsets.symmetric(vertical: 30),
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.cyanAccent)),
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
                "Enter OTP",
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
              length: 6,
              hapticFeedbackTypes: HapticFeedbackTypes.light,
              textStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary),
              // obscureText: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 65,
                fieldWidth: 50,
                inactiveColor: Theme.of(context).colorScheme.primary,
                activeFillColor: Colors.white,
              ),
              // activeColor: Theme.of(context).colorScheme.secondary),
              animationDuration: const Duration(milliseconds: 300),
              // backgroundColor: Colors.blue.shade50,
              // enableActiveFill: true,
              // errorAnimationController: errorController.add(ErrorAnimationType.shake);,
              // controller: textEditingController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                print(value);
                // setState(() {
                //   currentText = value;
                // });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
              appContext: context,
            ),
            Center(
              child: CustomActionButton(
                label: "Submit",
                onClick: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const TwoFactorAuthThird(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Container(
      color: colorScheme.background,
      child: body(context),
    );
  }
}
