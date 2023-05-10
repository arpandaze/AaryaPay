import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Register/bloc/register_bloc.dart';
import 'package:aaryapay/screens/Register/components/CustomRegisterButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class Identification extends StatelessWidget {
  const Identification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                              color: Theme.of(context).colorScheme.background),
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
                    child: Text("Identification",
                        style: Theme.of(context).textTheme.headlineSmall!),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      // padding: const EdgeInsets.all(15),
                      child: Text("1/3",
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.displayMedium!.merge(
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
                  prefixIcon: Container(
                    child: SvgPicture.asset(
                      "assets/icons/profile.svg",
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn),
                    ),
                  ),
                  onChanged: (value) => context.read<RegisterBloc>().add(
                        FirstNameChanged(firstName: value),
                      ),
                  placeHolder: "First Name",
                ),
                CustomTextField(
                  width: size.width,
                  padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                  prefixIcon: Container(
                    child: SvgPicture.asset(
                      "assets/icons/profile.svg",
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn),
                    ),
                  ),
                  onChanged: (value) => context.read<RegisterBloc>().add(
                        MiddleNameChanged(middleName: value),
                      ),
                  placeHolder: "Middle Name",
                ),
                CustomTextField(
                  width: size.width,
                  padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                  prefixIcon: Container(
                    child: SvgPicture.asset(
                      "assets/icons/profile.svg",
                      width: 20,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn),
                    ),
                  ),
                  onChanged: (value) => context.read<RegisterBloc>().add(
                        LastNameChanged(lastName: value),
                      ),
                  placeHolder: "Last Name",
                )
              ],
            ),
          ),
          Container(
            child: CustomRegisterButton(
              width: size.width * 0.78,
              borderRadius: 10,
              label: "Next",
              onClick: () => {context.read<RegisterBloc>().add(NextPage())},
            ),
          ),
        ],
      ),
    );
  }
}
