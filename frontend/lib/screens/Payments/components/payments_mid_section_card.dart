import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TimeRemaining {
  int timeRemainingMilliSeconds = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;
  int second = 0;

  TimeRemaining(this.timeRemainingMilliSeconds);

  String display() {
    if (timeRemainingMilliSeconds < 0) {
      return "The payment has expired";
    }

    second = (timeRemainingMilliSeconds / 1000).floor() % 60;
    minute = (timeRemainingMilliSeconds / (1000 * 60)).floor() % 60;
    hour = (timeRemainingMilliSeconds / (1000 * 60 * 60)).floor() % 24;
    day = (timeRemainingMilliSeconds / (1000 * 60 * 60 * 24)).floor();

    if (day == 0) {
      if (hour == 0) {
        if (minute == 0) {
          if (second > 5) {
            return "$second second(s)";
          }
          return "The payment is expiring soon";
        }
        return "$minute minute(s)";
      }
      return "$hour hour(s)";
    }
    return "$day day(s)";
  }
}

class PaymentsMidSectionCard extends StatelessWidget {
  const PaymentsMidSectionCard(
      {Key? key,
      required this.title,
      required this.amount,
      required this.sender,
      required this.reciever,
      required this.startDate,
      required this.endDate,
      required this.senderName})
      : super(key: key);

  final String title;
  final String amount;
  final String sender;
  final String reciever;
  final String senderName;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    var startDateObj = DateTime.fromMillisecondsSinceEpoch(
        int.parse(startDate) * 1000,
        isUtc: true);
    var endDateObj = DateTime.fromMillisecondsSinceEpoch(
        int.parse(endDate) * 1000,
        isUtc: true);
    var todayDateObj = DateTime.now().toUtc();
    // var todayDate = todayDateObj.millisecondsSinceEpoch.toInt() ~/ 1000;

    var totalDays = endDateObj.difference(startDateObj).inDays;
    var timeRemaining = endDateObj.difference(todayDateObj);
    var d1 = TimeRemaining(timeRemaining.inMilliseconds);

    //only for formatting
    var startDateFormattedString =
        DateFormat.yMMMEd().format(startDateObj.toLocal());
    var startTimeFormattedString =
        DateFormat.jms().format(startDateObj.toLocal());
    var endDateFormattedString =
        DateFormat.yMMMEd().format(endDateObj.toLocal());
    var endTimeFormattedString = DateFormat.jms().format(endDateObj.toLocal());
    var expiryString = d1.display();

    print(timeRemaining.inHours);
    print(expiryString);

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
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text("Sender : $sender", style: textTheme.bodyMedium),
            //     Text(
            //       "Reciever  : $reciever",
            //       style: textTheme.bodyMedium,
            //     ),
            //   ],
            // ),
            // NewWidget(startDateFormattedString: startDateFormattedString, textTheme: textTheme, startTimeFormattedString: startTimeFormattedString, endDateFormattedString: endDateFormattedString, endTimeFormattedString: endTimeFormattedString),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imageLoader(imageUrl: "imageUrxl"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$senderName",
                        style: textTheme.bodyLarge!
                            .merge(TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      Text("$sender")
                    ],
                  )
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
                              width: timeRemaining.inMilliseconds > 0
                                  ? constraints.maxWidth *
                                      (totalDays - timeRemaining.inDays) /
                                      totalDays
                                  : constraints.maxWidth,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        " $startTimeFormattedString, $startDateFormattedString ",
                        style: textTheme.bodySmall!.merge(
                          TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: size.width * 0.23,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: timeRemaining.inMilliseconds > 0
                        ? colorScheme.secondary
                        : colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    timeRemaining.inMilliseconds > 0
                        ? "$expiryString"
                        : "Expired",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium!.merge(
                      TextStyle(
                        color: timeRemaining.inMilliseconds > 0
                            ? colorScheme.onSecondary
                            : colorScheme.background,
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

// class NewWidget extends StatelessWidget {
//   const NewWidget({
//     super.key,
//     required this.startDateFormattedString,
//     required this.textTheme,
//     required this.startTimeFormattedString,
//     required this.endDateFormattedString,
//     required this.endTimeFormattedString,
//   });

//   final String startDateFormattedString;
//   final TextTheme textTheme;
//   final String startTimeFormattedString;
//   final String endDateFormattedString;
//   final String endTimeFormattedString;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       "assets/icons/calendar.svg",
//                       width: 16,
//                       height: 16,
//                       colorFilter: ColorFilter.mode(
//                         Theme.of(context).colorScheme.primary,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                     Text(
//                       " $startDateFormattedString ",
//                       style: textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       "assets/icons/clock.svg",
//                       width: 18,
//                       height: 18,
//                       colorFilter: ColorFilter.mode(
//                         Theme.of(context).colorScheme.primary,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                     Text(
//                       " $startTimeFormattedString ",
//                       style: textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       "assets/icons/calendar.svg",
//                       width: 18,
//                       height: 18,
//                       colorFilter: ColorFilter.mode(
//                         Theme.of(context).colorScheme.primary,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                     Text(
//                       " $endDateFormattedString ",
//                       style: textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               ),
             
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SvgPicture.asset(
//                       "assets/icons/clock.svg",
//                       width: 18,
//                       height: 18,
//                       colorFilter: ColorFilter.mode(
//                         Theme.of(context).colorScheme.primary,
//                         BlendMode.srcIn,
//                       ),
//                     ),
//                     Text(
//                       " $endTimeFormattedString ",
//                       style: textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
