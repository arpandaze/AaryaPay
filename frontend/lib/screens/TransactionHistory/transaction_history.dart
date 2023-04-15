import 'package:aaryapay/components/Wrapper.dart';
import 'package:aaryapay/components/TransactionsCard.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: body(context));
  }

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Wrapper(
      pageName: "statements",
      children: Container(
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
                    style: textTheme.titleMedium,
                  ),
                ),
                // Text("Transaction History"),
                RecentPaymentCard(),
                RecentPaymentCard(
                  transactionAmt: "-  \$50.00",
                  transactionColor: Theme.of(context).colorScheme.onSurface,
                ),
                RecentPaymentCard(),
                RecentPaymentCard(),
                RecentPaymentCard(
                  transactionAmt: "-  \$50.00",
                  transactionColor: Theme.of(context).colorScheme.onSurface,
                ),
                RecentPaymentCard(),
                RecentPaymentCard(),
                RecentPaymentCard(
                  transactionAmt: "-  \$50.00",
                  transactionColor: Theme.of(context).colorScheme.onSurface,
                ),
                RecentPaymentCard(
                  transactionAmt: "-  \$50.00",
                  transactionColor: Theme.of(context).colorScheme.onSurface,
                ),
                RecentPaymentCard(),
                RecentPaymentCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
