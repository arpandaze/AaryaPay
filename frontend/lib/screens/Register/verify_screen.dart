import 'package:aaryapay/screens/Register/bloc/register_bloc.dart';
import 'package:aaryapay/screens/Register/components/CustomRegisterButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:math' as math;

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Transform.rotate(
                              angle: -math.pi,
                              child: SvgPicture.asset(
                                "assets/icons/arrow2.svg",
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Text("Verify your Account",
                            style: Theme.of(context).textTheme.headlineSmall!),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: SizedBox(
                          // padding: const EdgeInsets.all(15),
                          child: Text("3/3",
                              style: Theme.of(context).textTheme.titleSmall!),
                        ),
                      ),
                    ),
                  ],
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
                height: size.height * 0.48,
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
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .merge(
                                TextStyle(
                                    height: 1.8,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Please enter the 6 digit code sent to: ",
                              style:
                                  Theme.of(context).textTheme.titleSmall!.merge(
                                        TextStyle(
                                            height: 1.8,
                                            // fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                            ),
                            Text(
                              "aaryapay@aaryapay.com",
                              style:
                                  Theme.of(context).textTheme.titleSmall!.merge(
                                        TextStyle(
                                            height: 1.8,
                                            fontWeight: FontWeight.w900,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: PinCodeTextField(
                        keyboardType: TextInputType.number,
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
                          activeFillColor:
                              Theme.of(context).colorScheme.background,
                        ),
                        // activeColor: Theme.of(context).colorScheme.secondary),
                        animationDuration: const Duration(milliseconds: 300),

                        onCompleted: (value) {
                          context
                              .read<RegisterBloc>()
                              .add(VerifyChanged(token: value));
                        },

                        onChanged: (value) {},
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
      },
    );
  }

  Widget button(BuildContext context, Size size) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (!state.status) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomRegisterButton(
                width: size.width * 0.78,
                borderRadius: 10,
                label: "Verify",
                onClick: () =>
                    {context.read<RegisterBloc>().add(VerifyClicked())},
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
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
}
