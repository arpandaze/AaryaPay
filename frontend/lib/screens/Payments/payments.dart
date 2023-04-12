import 'package:aaryapay/screens/Payments/components/payments_mid_section_card.dart';
import 'package:aaryapay/screens/Payments/components/payments_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/components/topbar.dart';
import 'package:aaryapay/screens/Home/components/midsection.dart';
import 'package:aaryapay/components/navbar.dart';
import 'package:aaryapay/components/Wrapper.dart';

class Payment {
  //modal class
  String title, amount, sender, reciever, startDate, endDate;

  Payment(
      {required this.title,
      required this.amount,
      required this.sender,
      required this.startDate,
      required this.endDate,
      required this.reciever});
}

class Payments extends StatelessWidget {
  const Payments({Key? key}) : super(key: key);

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Payment> list = [
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        reciever: "213621",
        startDate: "21 March 2020",
        endDate: "23 March 2020",
      ),
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        reciever: "213621",
        startDate: "21 March 2020",
        endDate: "23 March 2020",
      ),
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        reciever: "213621",
        startDate: "21 March 2020",
        endDate: "23 March 2020",
      ),
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        reciever: "213621",
        startDate: "21 March 2020",
        endDate: "23 March 2020",
      ),
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        reciever: "213621",
        startDate: "21 March 2020",
        endDate: "23 March 2020",
      ),
    ];
    return Wrapper(
      pageName: "payments",
      children: Container(
        // margin: EdgeInsets.only(bottom: 10),
        child: Expanded(
          child: SingleChildScrollView(
              child: Column(
            children: [
              PaymentsTopBar(
                items_length: list.length,
              ),
              ...list
                  .map(
                    (e) => PaymentsMidSectionCard(
                      title: e.title,
                      amount: e.amount,
                      sender: e.sender,
                      reciever: e.reciever,
                      startDate: e.startDate,
                      endDate: e.endDate,
                    ),
                  )
                  .toList()
            ],
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: body(context),
    );
  }
}
