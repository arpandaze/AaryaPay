
import 'package:aaryapay/screens/Send/components/transaction_details.dart';
import 'package:aaryapay/screens/Send/receiver_scan_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OfflineSend extends StatelessWidget {
  const OfflineSend({Key? key}) : super(key: key);
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
      Navigator.of(context).push(
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
                    child: Text("Transfer Initiated",
                        style: Theme.of(context).textTheme.headlineMedium!),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                      icon: SvgPicture.asset('assets/icons/close.svg',
                          width: 20,
                          height: 20,
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
              margin: const EdgeInsets.only(top: 20),
              child: QrImage(
                data:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                size: 240,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text("Let the Receiver Scan the",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                "QR Code to complete Offline Transaction",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const TransactionDetails(),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CustomActionButton(
                label: "Scan Confirmation",
                onClick: onClick,
              ),
            ),
          ),
        )
      ],
    );
  }
}
