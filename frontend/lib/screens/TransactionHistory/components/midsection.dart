import 'package:aaryapay/components/TransactionsCard.dart';
import 'package:flutter/material.dart';

class MidSection extends StatelessWidget {
  const MidSection({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
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
                transactionAmt: "1111150.00",
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
              RecentPaymentCard(
                isDebit: true,
                finalAmt: "18153.64",
                label: "Apple Payment",
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
              RecentPaymentCard(
                isDebit: true,
                finalAmt: "18153.64",
                label: "Apple Payment",
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
      ),
    );
  }
}
