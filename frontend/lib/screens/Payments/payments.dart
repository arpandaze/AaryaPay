import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Payments/bloc/payments_bloc.dart';
import 'package:aaryapay/screens/Payments/components/payments_mid_section_card.dart';
import 'package:aaryapay/screens/Payments/components/payments_top_bar.dart';
import 'package:aaryapay/screens/Send/offline_send.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Payment {
  //modal class
  String title, amount, sender, reciever, startDate, endDate, senderName;

  Payment({
    required this.title,
    required this.amount,
    required this.sender,
    required this.senderName,
    required this.startDate,
    required this.endDate,
    required this.reciever,
  });
}

class Payments extends StatelessWidget {
  const Payments({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Payment> list = [
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        senderName: "John Doe",
        reciever: "213621",
        startDate: "1685130226",
        endDate: "1685475826",
      ),
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        senderName: "John Doe",
        reciever: "213621",
        startDate: "1685130226",
        endDate: "1685475826",
      ),
    ];
    return BlocConsumer<DataBloc, DataState>(
      listener: (context, dataState) {
        // TODO: implement listener
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, dataState) {
        return BlocProvider(
          create: (context) => PaymentsBloc()
            ..add(PaymentsLoad(
                transactions:
                    dataState.transactions.getUnsubmittedTransactions())),
          child: BlocConsumer<PaymentsBloc, PaymentsState>(
            listener: (context, state) {},
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return Container(
                clipBehavior: Clip.hardEdge,
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  color: Color(0xfff4f6f4),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PaymentsTopBar(
                          items_length: state.transactions?.length ?? 0,
                          total_amount: (state.transactions != null &&
                                  state.transactions!.isNotEmpty)
                              ? state.transactions!
                                  .map((e) => e.amount)
                                  .reduce((value, element) => value + element)
                                  .toString()
                              : "0",
                        ),
                        if (dataState.isReady && state.transactions != null)
                          ...state.transactions!
                              .map(
                                (item) => GestureDetector(
                                  child: PaymentsMidSectionCard(
                                    title: item.isDebit
                                        ? "Debited Payment"
                                        : "Credited Payment",
                                    amount: item.amount.toString(),
                                    sender: item.senderId
                                        .toString()
                                        .substring(0, 8),
                                        
                                    reciever: item.isDebit
                                        ? item.receiverId
                                            .toString()
                                            .substring(0, 8)
                                        : "${dataState.profile?.firstName} ${dataState.profile?.lastName}",
                                    senderName: !item.isDebit
                                        ? item.senderId
                                            .toString()
                                            .substring(0, 8)
                                        : "${dataState.profile?.firstName} ${dataState.profile?.lastName}",
                                    startDate: (item.generationTime
                                                .millisecondsSinceEpoch ~/
                                            1000)
                                        .toString(),
                                    endDate: (item.generationTime
                                                    .millisecondsSinceEpoch ~/
                                                1000 +
                                            3 * 24 * 60 * 61)
                                        .toString(),
                                  ),
                                  onTap: () => {
                                    Utils.mainAppNav.currentState!.push(
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            OfflineSend(
                                          name: item.senderId ==
                                                  dataState.profile!.id
                                              ? "${dataState.profile!.firstName} ${dataState.profile!.lastName}"
                                              : item.senderId
                                                  .toString()
                                                  .substring(0, 8),
                                          transaction: item,
                                        ),
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
                                                  child: OfflineSend(
                                                      name: item.senderId ==
                                                              dataState
                                                                  .profile!.id
                                                          ? "${dataState.profile!.firstName} ${dataState.profile!.lastName}"
                                                          : item.senderId
                                                              .toString()
                                                              .substring(0, 8),
                                                      transaction: item),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  },
                                ),
                              )
                              .toList(),
                        if (!(dataState.isReady && state.transactions == null))
                          Text("No Pending transactions"),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
