import 'package:aaryapay/components/CustomFavoritesAvatar.dart';
import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Send/tvc_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentPaymentCard extends StatelessWidget {
  const RecentPaymentCard({
    Key? key,
    required this.transaction,
    required this.finalAmt,
  }) : super(key: key);

  final Transaction transaction;
  final String finalAmt;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: imageLoader(
              imageUrl: !transaction.isDebit
                  ? transaction.receiverId.toString()
                  : transaction.senderId.toString(),
              width: 55,
              errorImage: const CustomFavoritesAvatar(
                  width: 55, imagesUrl: "assets/images/default-pfp.png"),
            ),
          ),
          SizedBox(
            width: size.width * 0.40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    !transaction.isDebit
                        ? "${transaction.receiverFirstName!} ${transaction.receiverLastName!}"
                        : "${transaction.senderFirstName!} ${transaction.senderLastName!}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Text(
                    DateFormat.yMMMMd()
                        .format(transaction.receiverTvc!.timeStamp.toLocal()),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.merge(
                          TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.25,
                child: Text(
                  !transaction.isDebit
                      ? "-${transaction.amount.toString()}"
                      : "+${transaction.amount.toString()}",
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.labelMedium!.merge(
                      TextStyle(
                          fontSize: 18,
                          color: !transaction.isDebit
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.surfaceVariant)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
