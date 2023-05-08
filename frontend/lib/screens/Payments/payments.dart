import 'package:aaryapay/screens/Payments/components/payments_mid_section_card.dart';
import 'package:aaryapay/screens/Payments/components/payments_top_bar.dart';
import 'package:flutter/material.dart';

class Payment {
  //modal class
  String title, amount, sender, reciever, startDate, endDate;

  Payment({
    required this.title,
    required this.amount,
    required this.sender,
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
        reciever: "213621",
        startDate: "1682985600",
        endDate: "1683676800",
      ),
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        reciever: "213621",
        startDate: "1682899200",
        endDate: "1683027008",
      ),
      Payment(
        title: "Payment for momo",
        amount: "300",
        sender: "321371",
        reciever: "213621",
        startDate: "1682812800",
        endDate: "1682985600",
      ),
    ];
    return SizedBox(
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        ),
      ),
    );
  }
}
