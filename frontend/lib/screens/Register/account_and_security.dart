import 'dart:math';

import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomDatePicker.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Register/bloc/register_bloc.dart';
import 'package:aaryapay/screens/Register/components/CustomRegisterButton.dart';
import 'package:aaryapay/screens/Register/components/register_wrapper.dart';
import 'package:aaryapay/screens/Register/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var dateTime = new Map<String, String>();
    // dateTime["day"] = "";
    // dateTime["month"] = "";
    // dateTime["year"] = "";
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
                                      .add(PreviousPage())
                                },
                            child: const Icon(
                              FontAwesomeIcons.arrowLeftLong,
                              size: 20,
                            ))),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Text("Account and Security",
                        style: Theme.of(context).textTheme.headlineSmall!),
                  ),
                  Container(
                    width: size.width * 0.1,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(15),
                    child: Text("2/3",
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
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.displaySmall!.merge(
                            TextStyle(
                                height: 1.8,
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                    ),
                    Text(
                      "Fill the form to Sign Up for AaryaPay. Pay Anywhere, You Go",
                      style: Theme.of(context).textTheme.titleSmall!.merge(
                            TextStyle(
                                height: 2,
                                // fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                    ),
                  ],
                ),
                CustomTextField(
                  width: size.width,
                  padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                  prefixIcon: Icon(
                    FontAwesomeIcons.solidEnvelope,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onChanged: (value) => context.read<RegisterBloc>().add(
                        EmailChanged(email: value),
                      ),
                  placeHolder: "Email",
                ),
                DateField(
                  dateTime: (DateTime date) {
                    context.read<RegisterBloc>().add(DOBChanged(dob: date));
                  },
                ),
                CustomTextField(
                  width: size.width,
                  isPassword: true,
                  padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                  prefixIcon: Icon(
                    FontAwesomeIcons.lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onChanged: (value) => context.read<RegisterBloc>().add(
                        PasswordChanged(password: value),
                      ),
                  placeHolder: "Password",
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
        if (state.status != RegisterStatus.submitting) {
          return Column(
            children: [
              errorText(state.status),
              CustomRegisterButton(
                width: size.width * 0.78,
                borderRadius: 10,
                label: "Next",
                onClick: () => {
                 
                  context.read<RegisterBloc>().add(FormSubmitted())
                },
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
                margin: EdgeInsets.fromLTRB(
                    0, 0, size.width * 0.1, size.height * 0.05),
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
      case RegisterStatus.errorUnknown:
        return const Text("Something went wrong! Check you inputs!");
      case RegisterStatus.errorEmailUsed:
        return const Text("Email is already in use!");
      default:
        return const SizedBox.shrink();
    }
  }
}
