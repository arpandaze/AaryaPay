
import 'package:flutter/material.dart';
import 'package:aaryapay/components/TransactionsCard.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.centerLeft,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      
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
        Container(
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          width: double.infinity,
          child: Column(
            children: [
              RecentPaymentCard(
                isDebit: true,
                finalAmt: "18153.64",
                label: "Google Payment",
                transactionAmt: "50.00",
                date: "January 1 2020",
              ),
              RecentPaymentCard(
                label: "Amazon Payment Rebate asadasasdasdasdas",
                finalAmt: "18153.64",
                transactionAmt: "11150.00",
                date: "January 18 2020",
              ),
              RecentPaymentCard(
                label: "Amazon Payment",
                finalAmt: "18153.64",
                transactionAmt: "50.00",
                date: "January 18 2020",
              ),
              RecentPaymentCard(
                isDebit: true,
                label: "Amazon Payment",
                finalAmt: "18153.64",
                transactionAmt: "50.00",
                date: "January 18 2020",
              ),
              RecentPaymentCard(
                isDebit: true,
                finalAmt: "18153.64",
                label: "Apple Payment",
                transactionAmt: "50.00",
                date: "January 18 2020",
              ),
            ],
          ),
        ),
        

      ]),
    );
  }
}
