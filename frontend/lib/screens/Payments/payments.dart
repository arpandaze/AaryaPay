import 'package:aaryapay/screens/Payments/components/midsection.dart';
import 'package:aaryapay/screens/Payments/components/payments_mid_section_card.dart';
import 'package:aaryapay/screens/Payments/components/payments_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/components/Wrapper.dart';
class Payments extends StatelessWidget {
  const Payments({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Wrapper(
      pageName: "payments",
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
