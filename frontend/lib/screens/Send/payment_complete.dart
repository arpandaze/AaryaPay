import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Send/components/green_box.dart';
import 'package:aaryapay/screens/Send/components/trans_details.dart';
import 'package:aaryapay/screens/Send/receiver_scan_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentComplete extends StatelessWidget {
  const PaymentComplete({Key? key}) : super(key: key);
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
          pageBuilder: (context, animation1, animation2) =>
              const ReceiverConfirmation(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }

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
                    child: Text("Transfer Completed",
                        style: Theme.of(context).textTheme.titleLarge!),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
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
          ],
        ),
        Column(
          children: [
            Container(
                // padding: const EdgeInsets.symmetric(vertical: 2),
                ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: SvgPicture.asset('assets/icons/check.svg',
                  width: 80,
                  colorFilter: const ColorFilter.mode(
                      Color(0xff274233), BlendMode.srcIn)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Text("You Have Successfully sent!",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(
                      "250.00",
                      style: Theme.of(context).textTheme.labelLarge!.merge(
                            TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const GreenBox(
                recipient: "Elon Musk",
                amount: "2500000000000.00",
                date: "2020-04-27",
                sender: "Susraya Bir Singh Tuladhar",
                status: "Verified"),
            const TransactionDetails(
                recieverID: "@dropshipper",
                transactionNo: "1x903412321",
                time: "5:45 pm"),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomActionButton(
                width: size.width * 0.6,
                label: "Back to Home",
                onClick: () => Utils.mainAppNav.currentState!
                    .popUntil(ModalRoute.withName("/app")),
                textTheme: Theme.of(context).textTheme.titleMedium!.merge(
                      TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                borderRadius: 10,
              ),
              GestureDetector(
                onTap: () => {},
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 70,
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/share.svg',
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.background,
                              BlendMode.srcIn))
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
