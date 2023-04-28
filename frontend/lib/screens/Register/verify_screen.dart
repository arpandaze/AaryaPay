import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/screens/Register/bloc/register_bloc.dart';
import 'package:aaryapay/screens/Register/completed_screen.dart';
import 'package:aaryapay/screens/Register/components/CustomRegisterButton.dart';
import 'package:aaryapay/screens/Register/components/register_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.1,
                    // padding: const EdgeInsets.all(15),
                    alignment: Alignment.center,
                    child: Visibility(
                        visible: true,
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => {
                                  context
                                      .read<RegisterBloc>()
                                      .add(PreviousPage()),
                                  context
                                      .read<RegisterBloc>()
                                      .add(VerifyChanged(token: ""))
                                },
                            child: const Icon(
                              FontAwesome.arrow_left_long,
                              size: 20,
                            ))),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Text("Verify Your Account",
                        style: Theme.of(context).textTheme.headlineSmall!),
                  ),
                  Container(
                    width: size.width * 0.1,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(15),
                    child: Text("3/3",
                        style: Theme.of(context).textTheme.titleSmall!),
                  ),
                ],
              ),
            ),
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
            height: size.height * 0.45,
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Verify Your Account",
                      style: Theme.of(context).textTheme.displaySmall!.merge(
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
                          style: Theme.of(context).textTheme.titleSmall!.merge(
                                TextStyle(
                                    height: 1.8,
                                    // fontWeight: FontWeight.w500,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                        ),
                        Text(
                          "aaryapay@aaryapay.com",
                          style: Theme.of(context).textTheme.bodySmall!.merge(
                                TextStyle(
                                    height: 1.8,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                    textStyle: TextStyle(color: Colors.black),
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
                    
                    onChanged: (value) {
                      context
                          .read<RegisterBloc>()
                          .add(VerifyChanged(token: value));
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                ),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't Receive Code?",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Resend Code",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .merge(TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                            ),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
          button(context, size),
        ],
      ),
    );
  }

  Widget button(BuildContext context, Size size) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state.status != RegisterStatus.verifying) {
          return Column(
            children: [
              // errorText(state.status),
              CustomRegisterButton(
                width: size.width * 0.78,
                borderRadius: 10,
                label: "Next",
                onClick: () =>
                    {context.read<RegisterBloc>().add(VerifyClicked())},
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              errorText(state.status),
              Container(
                alignment: Alignment.bottomCenter,
                child: const CircularProgressIndicator(),
              )
            ],
          );
        }
      },
    );
  }

  Widget errorText(RegisterStatus state) {
    switch (state) {
      case RegisterStatus.wrongToken:
        return const Text("Invalid or expired token!");
      default:
        return const SizedBox.shrink();
    }
  }
}
