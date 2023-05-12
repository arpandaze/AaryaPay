import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? transactionItem;
  final String? recieverName;
  final String? senderName;

  const TransactionDetailsScreen({
    Key? key,
    this.transactionItem,
    this.recieverName,
    this.senderName,
  }) : super(key: key);
  //only for formatting

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: body(size, context),
      ),
    );
  }

  Widget body(Size size, BuildContext context) {
    var generationDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(transactionItem!["generation_time"].toString()) * 1000,
        isUtc: true);

    var verificationDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(transactionItem!["verification_time"].toString()) * 1000,
        isUtc: true);

    // var todayDate = todayDateObj.millisecondsSinceEpoch.toInt() ~/ 1000;

    //only for formatting
    var verificationDateFormattedString =
        DateFormat.yMMMMd().format(verificationDate.toLocal());
    var verificationTimeFormattedString =
        DateFormat.jm().format(verificationDate.toLocal());
    var generationDateFormattedString =
        DateFormat.yMMMMd().format(generationDate.toLocal());
    var generationTimeFormattedString =
        DateFormat.jm().format(generationDate.toLocal());

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: size.width * 0.1,
                  // padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: GestureDetector(
                      onTap: () => {
                        Utils.mainAppNav.currentState!.pop(true),
                      },
                      child: SvgPicture.asset(
                        "assets/icons/close.svg",
                        width: 18,
                        height: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/check.svg',
                        width: 80,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff274233),
                          BlendMode.srcIn,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Payment Successful",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/rupee.svg",
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Text(
                              transactionItem!["amount"].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .merge(
                                    TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transaction No.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Initiated Time",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Verification Time",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  transactionItem!["id"].substring(0, 8),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  "$generationDateFormattedString, $generationTimeFormattedString",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  "$verificationDateFormattedString, $verificationTimeFormattedString",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sender ID",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                            height: 3.0, fontSize: 13),
                                      ),
                                ),
                                Text(
                                  "Sender Name",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Receiver ID",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                                Text(
                                  "Receiver Name",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontSize: 13,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  transactionItem!["sender_id"]
                                      .substring(0, 13),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  senderName ?? "__",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  transactionItem!["receiver_id"]
                                      .substring(0, 13),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                                Text(
                                  recieverName ?? "__",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .merge(
                                        const TextStyle(
                                          height: 3.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
