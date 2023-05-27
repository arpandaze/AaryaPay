import 'package:aaryapay/components/CustomFavoritesAvatar.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecentPaymentCard extends StatelessWidget {
  RecentPaymentCard({
    Key? key,
    required this.label,
    required this.date,
    this.isDebit = false,
    required this.transactionAmt,
    required this.finalAmt,
    required this.uuid,
  }) : super(key: key);
  String label;
  String date;
  bool isDebit;
  String transactionAmt;
  String finalAmt;
  String uuid;
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
              imageUrl: uuid,
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
                Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: Text(
                    date,
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
              Container(
                width: size.width * 0.25,
                child: Text(
                  isDebit ? "-$transactionAmt" : "+$transactionAmt",
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.labelMedium!.merge(
                      TextStyle(
                          fontSize: 18,
                          color: isDebit
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
