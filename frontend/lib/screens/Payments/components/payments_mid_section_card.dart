import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

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

    var finalStartDate = DateFormat.yMMMEd().format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(startDate) * 1000));
    var finalStartTime = DateFormat.jms().format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(startDate) * 1000));

    var finalEndDate = DateFormat.yMMMEd()
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(endDate) * 1000));
    var finalEndTime = DateFormat.jms().format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(startDate) * 1000));

    var todayDate = DateTime.now().millisecondsSinceEpoch.toInt() ~/ 1000;
    var totalDays = int.parse(endDate) - int.parse(startDate);
    var totalFinalDate =
        DateTime.fromMillisecondsSinceEpoch((totalDays.toInt() * 1000)).day;

    var differenceInDate = int.parse(endDate) - todayDate;
    var finalDifferenceDate = int.parse(endDate) > todayDate
        ? DateTime.fromMillisecondsSinceEpoch((differenceInDate.toInt() * 1000))
            .day
        : -1;

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      width: size.width * 0.9,
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(50, 0, 0, 0),
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.4,
                  child: Text(
                    title,
                    style: textTheme.titleMedium!.merge(
                      const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
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
                      Text(
                        amount,
                        textAlign: TextAlign.right,
                        style: textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sender : $sender", style: textTheme.bodyMedium),
                Text(
                  "Reciever  : $reciever",
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/calendar.svg",
                              width: 16,
                              height: 16,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              " $finalStartDate ",
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/clock.svg",
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              " $finalStartTime ",
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
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
                              " $finalEndDate ",
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/clock.svg",
                              width: 18,
                              height: 18,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              " $finalEndTime ",
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        return Stack(
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            Container(
                              width: finalDifferenceDate != -1
                                  ? constraints.maxWidth *
                                      (totalFinalDate - finalDifferenceDate) /
                                      totalFinalDate
                                  : constraints.maxWidth,
                              height: 10,
                              decoration: BoxDecoration(
                                color: finalDifferenceDate > 1
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.primary,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            //bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  finalDifferenceDate != -1
                      ? "Safe expiry in $finalDifferenceDate day(s)"
                      : "The payment has expired",
                  style: textTheme.bodyMedium,
                ),
                Container(
                  width: size.width * 0.20,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: finalDifferenceDate > 1
                        ? colorScheme.secondary
                        : colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    finalDifferenceDate != -1 ? "Pending" : "Expired",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium!.merge(
                      TextStyle(
                        color: colorScheme.background,
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
