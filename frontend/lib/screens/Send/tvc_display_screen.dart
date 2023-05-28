import 'dart:convert';
import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Send/components/trans_details_outlined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math' as math;

class TVCDisplay extends StatelessWidget {
  bool sender;
  Transaction transaction;
  TVCDisplay({Key? key, required this.transaction, this.sender = true})
      : super(key: key);
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
        ));
  }

  Widget body(Size size, BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Transfer Completed",
                      style: Theme.of(context).textTheme.titleLarge!.merge(
                            const TextStyle(
                              height: 1.2,
                            ),
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => {Utils.mainAppNav.currentState!.pop()},
                      icon: SvgPicture.asset('assets/icons/close.svg',
                          width: 15,
                          height: 15,
                          colorFilter: const ColorFilter.mode(
                              Colors.black, BlendMode.srcIn)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: QrImageView(
                data: !transaction.isDebit
                    ? base64Encode(transaction.receiverTvc!.toBytes())
                    : base64Encode(transaction.senderTvc!.toBytes()),
                size: 240,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                  "Let the ${!transaction.isDebit ? "Receiver" : "Sender"} Scan the \n QR Code to Sync the Completed Transaction",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .merge(const TextStyle(height: 1.8))),
            ),
            TransactionDetailsOutlineBox(
              initiator: transaction.senderId.toString().substring(0, 8),
              amount: "Rs. ${transaction.amount}",
              date: DateFormat.yMMMMEEEEd().format(transaction.generationTime),
            ),
          ],
        )
      ],
    );
  }
}
