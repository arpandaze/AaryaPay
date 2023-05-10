import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/QrScan/components/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aaryapay/screens/QrScan/qrscan_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
    QRViewController? controller;
    return BlocConsumer<QrScannerBloc, QrScannerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      buildWhen: ((prev, next) => prev != next),
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              child: QRView(
                key: context.read<QrScannerBloc>().qrKey,
                onQRViewCreated: (controller) =>
                    controller.scannedDataStream.listen((data) {
                  context
                      .read<QrScannerBloc>()
                      .add(QrCodeScanned(data.rawBytes!));
                }),
                overlay: QrScannerOverlayShape(
                    borderColor: Theme.of(context).colorScheme.background,
                    borderRadius: 34,
                    borderWidth: 10,
                    cutOutSize: (size.width < 400 || size.height < 400)
                        ? 150.0
                        : 300.0),
              ),
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
                        onPressed: () => Navigator.of(context).pop(),
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
                Container(
                  child: Text(
                    "to Pay",
                    style: Theme.of(context).textTheme.displaySmall!.merge(
                        const TextStyle(height: 1.5).merge(TextStyle(
                            color: Theme.of(context).colorScheme.background))),
                  ),
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
