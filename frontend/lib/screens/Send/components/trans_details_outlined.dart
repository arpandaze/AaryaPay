
import 'package:flutter/material.dart';

class TransactionDetailsOutlineBox extends StatelessWidget {
  final String? initiator;
  final String? amount;
  final String? date;
  const TransactionDetailsOutlineBox({
    super.key,
    this.initiator,
    this.amount,
    this.date
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(25,25,25,35),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Transaction Details",
              style: Theme.of(context).textTheme.titleLarge!.merge(
                    TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w800),
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Initiator",
                style: Theme.of(context).textTheme.titleSmall!.merge(
                      TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900),
                    ),
              ),
              Text(initiator ?? "",
                  style: Theme.of(context).textTheme.titleSmall!),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Amount",
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w900),
                      ),
                ),
                Text(amount ?? "", style: Theme.of(context).textTheme.titleSmall!),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: Theme.of(context).textTheme.titleSmall!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w900),
                      ),
                ),
                Text(date ?? "",
                    style: Theme.of(context).textTheme.titleSmall!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
