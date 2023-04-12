import 'package:flutter/material.dart';
import 'package:aaryapay/components/topbar.dart';
import 'package:aaryapay/screens/Home/components/midsection.dart';
import 'package:aaryapay/components/navbar.dart';
import 'package:aaryapay/components/Wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentsMidSectionCard extends StatelessWidget {
  const PaymentsMidSectionCard(
      {Key? key,
      this.title,
      this.amount,
      this.sender,
      this.reciever,
      this.startDate,
      this.endDate})
      : super(key: key);

  final String? title;
  final String? amount;
  final String? sender;
  final String? reciever;
  final String? startDate;
  final String? endDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      width: size.width * 0.9,
      height: size.height * 0.25,
      decoration: BoxDecoration(
          border: Border.all(color: colorScheme.surface),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? "Payment For Momo",
                  style: textTheme.headlineSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      child: Text(
                        "Rs.",
                        style: textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      amount ?? "300",
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sender : ${sender ?? "32318"}",
                  style: textTheme.labelSmall,
                ),
                Text(
                  "Reciever  : ${reciever ?? "465823"}",
                  style: textTheme.labelSmall,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/calendar.svg",
                      width: 10,
                      height: 10,
                      color: colorScheme.primary,
                    ),
                    Text(
                      " Start Time: ${startDate ?? "March 21 2023"}",
                      style: textTheme.labelSmall,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/bullseye.svg",
                      width: 10,
                      height: 10,
                      color: colorScheme.primary,
                    ),
                    Text(
                      " End Time: ${endDate ?? "March 21 2023"}",
                      style: textTheme.labelSmall,
                    )
                  ],
                )
              ],
            ),
            //bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sale expiry in 3 days", style: textTheme.bodySmall),
                Container(
                    width: size.width * 0.18,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Pending",
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall!.merge(
                        TextStyle(color: colorScheme.background),
                      ),
                    )),
              ],
            )
          ]),
    );
  }
}
