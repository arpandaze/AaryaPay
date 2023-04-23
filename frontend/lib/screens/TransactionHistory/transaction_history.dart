import 'package:aaryapay/components/Wrapper.dart';
import 'package:aaryapay/components/TransactionsCard.dart';
import 'package:aaryapay/screens/TransactionHistory/components/midsection.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Wrapper(
      pageName: "statements",
      children: MidSection(size: size),
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
