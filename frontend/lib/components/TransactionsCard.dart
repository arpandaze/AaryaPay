import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:flutter/material.dart';

class RecentPaymentCard extends StatelessWidget {
  RecentPaymentCard(
      {Key? key,
      required this.label,
      required this.date,
      this.isDebit = false,
      required this.transactionAmt,
      required this.finalAmt})
      : super(key: key);
  String label;
  String date;
  bool isDebit;
  String transactionAmt;
  String finalAmt;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      // decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          // width: 350,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: const CustomCircularAvatar(
                    size: 20,
                    imageSrc: AssetImage("assets/images/default-pfp.png")),
              ),
              Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width * 0.45,
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge!.merge(
                              const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Container(
                        width: size.width * 0.45,
                        child: Text(
                          date,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    ]),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              width: size.width * 0.25,
              margin: const EdgeInsets.only(right: 10),
              child: Text(
                isDebit ? "-$transactionAmt" : "+$transactionAmt",
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.labelSmall!.merge(TextStyle(
                    color: isDebit
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.surfaceVariant)),
              ),
            ),
            Container(
              width: size.width * 0.25,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                finalAmt,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.labelSmall!.merge(
                      TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
