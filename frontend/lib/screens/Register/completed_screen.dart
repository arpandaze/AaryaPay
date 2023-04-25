import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:aaryapay/screens/Login/welcome_screen.dart';
import 'package:aaryapay/screens/Register/bloc/register_bloc.dart';
import 'package:aaryapay/screens/Register/components/register_wrapper.dart';
import 'package:aaryapay/screens/Send/offline_send.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({Key? key}) : super(key: key);

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
                            onTap: () => {context.read<RegisterBloc>().add(PreviousPage())},
                            child: const Icon(
                              FontAwesomeIcons.arrowLeftLong,
                              size: 20,
                            ))),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(15),
                    child: Text("Completed",
                        style: Theme.of(context).textTheme.headlineSmall!),
                  ),
                  Container(
                    width: size.width * 0.1,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.all(15),
                    child: Text("",
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
            padding: EdgeInsets.symmetric(vertical:18,horizontal:18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "You Are, All Set",
                      style: Theme.of(context).textTheme.displaySmall!.merge(
                            TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        "Does anyone even read this text. No. Why are you reading this text. Just login already, this text is worthless.",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .merge(const TextStyle(height: 2.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: CustomActionButton(
              width: size.width * 0.78,
              borderRadius: 10,
              label: "Next",
              onClick: () => {},
            ),
          ),
        ],
      ),
    );
  }
}
