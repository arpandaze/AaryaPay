import 'package:flutter/material.dart';

class RecentPaymentCard extends StatelessWidget {
  RecentPaymentCard(
      {Key? key,
      this.label,
      this.date,
      this.transactionAmt,
      this.transactionColor})
      : super(key: key);
  String? label = "amazon";
  String? date = "3rd Dec 2021";
  String? transactionAmt = "+ \$50.0";
  Color? transactionColor = const Color(0xff78BE7C);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            // width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/pfp.jpeg")),
                ),
                Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            label ??= "Amazon Payment",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .merge(const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        Container(
                          child: Text(
                            date ??= "3rd Dec 2021",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              transactionAmt ??= "+ \$50.00",
              style: Theme.of(context).textTheme.bodyMedium!.merge(TextStyle(
                  color: transactionColor ??=
                      Theme.of(context).colorScheme.outline)),
            ),
          )
        ]),
      ),
    );
  }
}
