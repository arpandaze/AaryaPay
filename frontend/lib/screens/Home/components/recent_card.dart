import 'package:aaryapay/screens/Home/components/recent_transfer.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Home/components/recent_transfer.dart';
import 'package:aaryapay/components/CustomAddButton.dart';
import 'package:aaryapay/screens/Home/components/recent_payment_card.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.centerLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            child: Text(
              "Recent Transfer",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 5, 15),
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: CustomAddButton(),
                    ),
                    Expanded(
                      child: Container(
                        
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.black)),
                        width: size.width * 0.8,
                        // height: size.height * 0.3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: RecentTransfer(
                                      imageSrc:
                                          AssetImage("assets/images/pfp.jpeg"),
                                      label: "Mukesh"),
                                ),
                                Container(
                                  child: RecentTransfer(
                                      imageSrc:
                                          AssetImage("assets/images/pfp.jpeg"),
                                      label: "Mukesh"),
                                ),
                                Container(
                                  child: RecentTransfer(
                                      imageSrc:
                                          AssetImage("assets/images/pfp.jpeg"),
                                      label: "Mukesh"),
                                ),
                                Container(
                                  child: RecentTransfer(
                                      imageSrc:
                                          AssetImage("assets/images/pfp.jpeg"),
                                      label: "Mukesh"),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "Recent Payment",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Container(
                    child: Text(
                  "See All",
                  style: Theme.of(context).textTheme.bodyMedium,
                ))
              ],
            ),
          ),
          Container(
            child: Column(children: [
              RecentPaymentCard(),
              RecentPaymentCard(label: "Discord Nitro Win"),
              RecentPaymentCard(
                transactionAmt: "-  \$50.00",
                transactionColor: Theme.of(context).colorScheme.surface,
              ),
              RecentPaymentCard(
                transactionAmt: "-  \$50.00",
                transactionColor: Theme.of(context).colorScheme.surface,
              ),
              RecentPaymentCard(label: "eSewa Voucher Win"),
              RecentPaymentCard(),
              RecentPaymentCard(
                transactionAmt: "-  \$50.00",
                transactionColor: Theme.of(context).colorScheme.surface,
              ),
              RecentPaymentCard(),
              RecentPaymentCard(
                transactionAmt: "-  \$50.00",
                transactionColor: Theme.of(context).colorScheme.surface,
              ),
              RecentPaymentCard(),
            ]),
          ),


        ]),
      ),
    );
  }
}
