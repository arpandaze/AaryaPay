import 'package:aaryapay/global/caching/transaction.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Send/components/green_box.dart';
import 'package:aaryapay/screens/Send/tvc_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomAnimationWidget.dart';
import 'package:intl/intl.dart';

class PaymentComplete extends StatelessWidget {
  final Transaction transaction;
  final bool sender;
  const PaymentComplete(
      {Key? key, required this.transaction, required this.sender})
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
    void onClick() {
      Utils.mainAppNav.currentState!.push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => TVCDisplay(
            transaction: transaction,
            sender: sender,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.decelerate,
            );

            return Stack(
              children: [
                FadeTransition(
                  opacity: Tween<double>(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(curve),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(curve),
                  child: FadeTransition(
                    opacity: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(curve),
                    child: TVCDisplay(
                      transaction: transaction,
                      sender: sender,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return Stack(
      alignment: Alignment.topCenter,
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
                padding: const EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => {
                    Utils.mainAppNav.currentState!
                        .popUntil(ModalRoute.withName("/app"))
                  },
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
        Positioned(
          top: 50,
          child: Container(child: Utils.background),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        child: const CustomAnimationWidget(
                          assetSrc: 'assets/animations/check.json',
                          repeat: false,
                        ),
                      ),
                      Text("Transaction Synced Successfully!",
                          style: Theme.of(context).textTheme.titleMedium),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/rupee.svg',
                                width: 24,
                                colorFilter: const ColorFilter.mode(
                                    Color(0xff274233), BlendMode.srcIn)),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Text(
                                transaction.amount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .merge(
                                      TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: size.height * 0.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GreenBox(
                          receiveruuid: transaction.receiverId.toString(),
                          recipient:
                              "${transaction.receiverFirstName} ${transaction.receiverLastName}",
                          amount: transaction.amount.toString(),
                          date: DateFormat.yMMMMd()
                              .format(transaction.generationTime),
                          sender:
                              "${transaction.senderFirstName} ${transaction.senderLastName}",
                          status: "Verified",
                        ),
                        CustomActionButton(
                          width: size.width * 0.7,
                          borderRadius: 10,
                          label: "Show Certificate",
                          onClick: onClick,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
