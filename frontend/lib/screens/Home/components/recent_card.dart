import 'dart:math';

import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Home/components/bloc/recent_card_bloc.dart';
import 'package:aaryapay/screens/TransactionHistory/components/transaction_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/components/RecentPaymentCard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<DataBloc, DataState>(
      listener: (context, dataState) {},
      buildWhen: (previous, current) => previous != current,
      builder: (context, dataState) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Recent Transactions",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
              ),
              dataState.isLoaded
                  ? BlocProvider(
                      create: (context) => RecentCardBloc()..add(TransactionLoad(transactions: dataState.transactions)),
                      child: BlocConsumer<RecentCardBloc, RecentCardState>(
                        listener: (context, state) {
                          if (state.senderName != null &&
                              state.receiverName != null &&
                              state.item != null) {
                            Utils.mainAppNav.currentState!.push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        TransactionDetailsScreen(
                                  transactionItem: state.item,
                                  recieverName: state.receiverName,
                                  senderName: state.senderName,
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
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
                                          child: TransactionDetailsScreen(
                                            transactionItem: state.item,
                                            recieverName: state.receiverName,
                                            senderName: state.senderName,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            padding: const EdgeInsets.only(left: 10, bottom: 5),
                            width: double.infinity,
                            child: Column(
                              children: state.isLoaded && dataState.isLoaded
                                  ? [
                                      ...state.transactionHistory!
                                          .take(min(
                                              state.transactionHistory!.length,
                                              5))
                                          .map(
                                            (item) => GestureDetector(
                                              onTapDown: (details) {
                                                context
                                                    .read<RecentCardBloc>()
                                                    .add(
                                                      LoadParticularUser(
                                                        item: item,
                                                        receiverID: item
                                                            .receiverTvc!
                                                            .bkvc
                                                            .userID
                                                            .toString(),
                                                        senderID: item
                                                            .senderTvc!
                                                            .bkvc
                                                            .userID
                                                            .toString(),
                                                      ),
                                                    );
                                              },
                                              onTapUp: (details) {
                                                context
                                                    .read<RecentCardBloc>()
                                                    .add(ClearLoadedUser());
                                              },
                                              child: RecentPaymentCard(
                                                finalAmt: dataState
                                                    .bkvc!.availableBalance
                                                    .toString(),
                                                transaction: item,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ]
                                  : [
                                      Text("No Recent Transactions"),
                                    ],
                            ),
                          );
                        },
                      ),
                    )
                  : const CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
