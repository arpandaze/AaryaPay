import 'package:aaryapay/screens/Register/completed_screen.dart';
import 'package:aaryapay/screens/Register/components/register_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RegisterWrapper(
      backButton: true,
      backButttonFunction: () => {
        Navigator.pop(context),
      },
      title: "Verify your account",
      actionButtonLabel: "Next",
      actionButtonFunction: () => Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const CompletedScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ),
      children: _midsection(context, size),
    );
  }

  Widget _midsection(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Verify Your Account",
              style: Theme.of(context).textTheme.headlineMedium!.merge(
                    TextStyle(
                        height: 1.8,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary),
                  ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please enter the 6 digit code sent to: ",
                  style: Theme.of(context).textTheme.bodySmall!.merge(
                        TextStyle(
                        height: 1.8,
                            // fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                ),
                Text(
                  "aaryapay@aaryapay.com",
                  style: Theme.of(context).textTheme.bodySmall!.merge(
                        TextStyle(
                        height: 1.8,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 40),
          child: PinCodeTextField(
            length: 6,
            hapticFeedbackTypes: HapticFeedbackTypes.light,
            textStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
        )
      ],
    );
  }
}
