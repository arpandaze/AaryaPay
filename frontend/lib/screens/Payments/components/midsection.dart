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

class Midsection extends StatelessWidget {
  const Midsection({
    super.key,
    required this.size,
  });
  final Size size;

  @override
  Widget build(BuildContext context) {
    List<Payment> list = [
      Payment(
        title: "Payment for momo",
        amount: "3231320",
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
