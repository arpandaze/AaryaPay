import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Home/components/midsection.dart';
import 'package:aaryapay/components/Wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Wrapper(
      pageName: "home",
      children: Midsection(size: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: body(context),
    );
  }
}
