import 'package:aaryapay/components/Wrapper.dart';
import 'package:aaryapay/components/TransactionsCard.dart';
import 'package:aaryapay/screens/TransactionHistory/bloc/transcation_bloc.dart';
import 'package:aaryapay/screens/TransactionHistory/components/midsection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => TranscationBloc(),
      child: Wrapper(
        pageName: "statements",
        children: MidSection(size: size),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: body(context),
    );
  }
}
