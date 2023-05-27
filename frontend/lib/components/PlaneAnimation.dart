import 'package:flutter/material.dart';
import 'package:aaryapay/components/CustomAnimationWidget.dart';

class PlaneAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: body(size, context),
        ));
  }

  Widget body(Size size, BuildContext context) {
    return Center(
      child: Container(
          child: CustomAnimationWidget(
          repeat: true,
        assetSrc: 'assets/animations/paperplane.json',
          width: 500,
          height: 500,
      )),
    );
  }
}
