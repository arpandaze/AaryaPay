import 'package:aaryapay/components/TransactionsCard.dart';
import 'package:aaryapay/screens/TransactionHistory/bloc/transcation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MidSection extends StatelessWidget {
  const MidSection({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscationBloc, TranscationState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
          clipBehavior: Clip.none,
          width: size.width,
          height: size.height * 0.75,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Transaction History",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (state.loaded)
                    ...state.transactionHistory!
                        .map((item) => RecentPaymentCard(
                            label: "Google Payment",
                            date: item['generation_time'],
                            transactionAmt: item["amount"].toString(),
                            finalAmt: "1200"))
                        .toList()
                        .reversed
                  else
                    Text("${state.loaded}")
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
