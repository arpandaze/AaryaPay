import 'package:aaryapay/components/CustomAnimationWidget.dart';
import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final Transaction? transactionItem;
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
      backgroundColor: Color(0xfff4f6fa),
      body: SafeArea(
        top: false,
        bottom: true,
        left: true,
        right: true,
        child: body(size, context),
      ),
    );
  }

  Widget body(Size size, BuildContext context) {
    //only for formatting
    var verificationDateFormattedString = DateFormat.yMMMMd()
        .format(transactionItem!.senderTvc!.verificationTime);
    var verificationTimeFormattedString =
        DateFormat.jm().format(transactionItem!.senderTvc!.verificationTime);
    var generationDateFormattedString =
        DateFormat.yMMMMd().format(transactionItem!.senderTvc!.generationTime);
    var generationTimeFormattedString =
        DateFormat.jm().format(transactionItem!.senderTvc!.generationTime);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Container(
                      // padding: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          "assets/icons/close.svg",
                          width: 18,
                          height: 18,
                        ),
                        onPressed: () {
                          Utils.mainAppNav.currentState!.popUntil(
                            ModalRoute.withName("/app"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: kElevationToShadow[4]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(
                        children: [
                          CustomAnimationWidget(
                            repeat: true,
                            assetSrc: 'assets/animations/check.json',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
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
                                  Theme.of(context).colorScheme.onBackground,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  transactionItem!.senderTvc!.amount.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .merge(
                                        TextStyle(
                                          fontSize: 38,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
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
                                    color:
                                        Theme.of(context).colorScheme.outline),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
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
                                      "Initiated Date",
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
                                      "Verification Date",
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
                                      transactionItem!.id!.substring(0, 8),
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
                                      generationDateFormattedString,
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
                                      generationTimeFormattedString,
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
                                      verificationDateFormattedString,
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
                                      verificationTimeFormattedString,
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
                            padding: const EdgeInsets.only(top: 30),
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
                                      transactionItem!.senderTvc!.bkvc.userID
                                          .toString()
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
                                      "${transactionItem!.senderFirstName} ${transactionItem!.senderLastName}",
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
                                      transactionItem!.receiverTvc!.bkvc.userID
                                          .toString()
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
                                      "${transactionItem!.receiverFirstName} ${transactionItem!.receiverLastName}",
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
            ),
          ),
        ],
      ),
    );
  }
}
