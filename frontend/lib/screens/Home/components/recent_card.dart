
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
              // Container(
              //     margin: EdgeInsets.only(right: 10),
              //     child: Text(
              //       "See All",
              //       style: Theme.of(context).textTheme.bodyMedium!.merge(
              //           TextStyle(
              //               color: Theme.of(context).colorScheme.primary)),
              //     )),
            ],
          ),
        ),
        Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
          // margin: EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(left: 10, bottom: 5),
          width: double.infinity,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(children: [
                  RecentPaymentCard(),
                  RecentPaymentCard(label: "Discord Nitro Win"),
                  RecentPaymentCard(
                    transactionAmt: "-  \$50.00",
                    transactionColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  RecentPaymentCard(
                    transactionAmt: "-  \$50.00",
                    transactionColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  RecentPaymentCard(label: "eSewa Voucher Win"),
                  RecentPaymentCard(),
                  RecentPaymentCard(
                    transactionAmt: "-  \$50.00",
                    transactionColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  RecentPaymentCard(),
                  RecentPaymentCard(
                    transactionAmt: "-  \$50.00",
                    transactionColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  RecentPaymentCard(),
                ]),
              ),
            ],
          ),
        ),
        

      ]),
    );
  }
}
