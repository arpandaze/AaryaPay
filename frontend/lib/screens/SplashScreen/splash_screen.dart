import 'package:aaryapay/components/CustomAnimationWidget.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.3,
                    child: Utils.mainlogo,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'AaryaPay',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .merge(TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  CustomAnimationWidget(
                      width: 50,
                      height: 50,
                      repeat: true,
                      assetSrc: "assets/animations/loading.json")
                ],
              ),
            )));
  }
}
