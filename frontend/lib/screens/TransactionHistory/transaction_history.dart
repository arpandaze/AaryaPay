import 'package:aaryapay/components/TransactionsCard.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/TransactionHistory/bloc/transcation_bloc.dart';
import 'package:aaryapay/screens/TransactionHistory/components/tranasaction_detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => TranscationBloc(),
      child: BlocBuilder<TranscationBloc, TranscationState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Container(
            color: Theme.of(context).colorScheme.background,
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
                          .map((item) => GestureDetector(
                                onTap: () => {
                                  Utils.mainAppNav.currentState!.push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const TransactionDetailsScreen(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final curve = CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.decelerate,
                                        );

                                        return Stack(
                                          children: [
                                            FadeTransition(
                                              opacity: Tween<double>(
                                                begin: 1.0,
                                                end: 0.0,
                                              ).animate(curve),
                                            ),
                                            SlideTransition(
                                              position: Tween<Offset>(
                                                begin: const Offset(0.0, 1.0),
                                                end: Offset.zero,
                                              ).animate(curve),
                                              child: FadeTransition(
                                                opacity: Tween<double>(
                                                  begin: 0.0,
                                                  end: 1.0,
                                                ).animate(curve),
                                                child:
                                                    const TransactionDetailsScreen(),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                },
                                child: RecentPaymentCard(
                                    label: "Google Payment",
                                    date: DateFormat.yMMMMd().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                              item['generation_time'] * 1000,
                                              isUtc: true)
                                          .toLocal(),
                                    ),
                                    transactionAmt: item["amount"].toString(),
                                    finalAmt: "1200"),
                              ))
                          .toList()
                          .reversed
                    else
                      const Text("Nothing to show yet")
                  ],
                ),
              ),
            ),
          );
        },
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
