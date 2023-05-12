import 'dart:typed_data';

import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/QrScan/components/bottom_bar.dart';
import 'package:aaryapay/screens/QrScan/components/qr_scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aaryapay/screens/QrScan/qrscan_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => QrScannerBloc(),
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            top: true,
            bottom: true,
            left: true,
            right: true,
            child: body(size, context),
          )),
    );
  }

  Widget body(Size size, BuildContext context) {
    return BlocConsumer<QrScannerBloc, QrScannerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      buildWhen: ((prev, next) => prev != next),
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              child: MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.noDuplicates,
                  facing: CameraFacing.back,
                  torchEnabled: false,
                ),
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  final Uint8List? image = capture.image;
                  for (final barcode in barcodes) {
                    context
                        .read<QrScannerBloc>()
                        .add(QrCodeScanned(barcode.rawBytes!));
                  }
                },
              ),
            ),
            QRScannerOverlay(
              overlayColour: Colors.black.withOpacity(0.5),
            ),
            // Text(state.code ?? ""),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () => {
                          context.read<QrScannerBloc>().add(CloseScanner()),
                          Utils.mainAppNav.currentState!.pop()
                        },
                        icon: SvgPicture.asset('assets/icons/close.svg',
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.background,
                                BlendMode.srcIn)),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Text(
                    "Scan QR Code",
                    style: Theme.of(context).textTheme.displaySmall!.merge(
                          const TextStyle(height: 1.5).merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                        ),
                  ),
                ),
                Text(
                  "to Pay",
                  style: Theme.of(context).textTheme.displaySmall!.merge(
                      const TextStyle(height: 1.5).merge(TextStyle(
                          color: Theme.of(context).colorScheme.background))),
                ),
              ],
            ),
            const BottomQrBar(),
          ],
        );
      },
    );
  }
}
