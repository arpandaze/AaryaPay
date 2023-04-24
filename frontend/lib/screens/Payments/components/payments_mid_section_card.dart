import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentsMidSectionCard extends StatelessWidget {
  const PaymentsMidSectionCard(
      {Key? key,
      required this.title,
      required this.amount,
      required this.sender,
      required this.reciever,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  final String title;
  final String amount;
  final String sender;
  final String reciever;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      width: size.width * 0.9,
      height: size.height * 0.25,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(50, 0, 0, 0)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width * 0.4,
                  child: Text(
                    title,
                    style: textTheme.titleMedium!
                        .merge(TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                Container(
                  width: size.width * 0.40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Rs.",
                        textAlign: TextAlign.left,
                        style: textTheme.titleSmall,
                      ),
                      Container(
                        child: Text(
                          amount,
                          textAlign: TextAlign.right,
                          style: textTheme.headlineMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sender : ${sender}", style: textTheme.bodyMedium
                ),
                Text(
                  "Reciever  : ${reciever}",
                  style: textTheme.bodyMedium,
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
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      " Start: ${startDate}",
                      style: textTheme.bodyMedium,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/bullseye.svg",
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                          BlendMode.srcIn),
                    ),
                    Text(
                      " End: ${endDate}",
                      style: textTheme.bodyMedium,
                    )
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.845,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
            //bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sale expiry in 3 days", style: textTheme.bodySmall),
                Container(
                    width: size.width * 0.18,
                    padding: const EdgeInsets.all(5),
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
