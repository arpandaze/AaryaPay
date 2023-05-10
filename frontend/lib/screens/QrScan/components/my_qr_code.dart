import 'dart:math' as math;
import 'dart:typed_data';
import 'package:aaryapay/components/QRImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQRCode extends StatelessWidget {
  const MyQRCode({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.5,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          width: size.width,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Theme.of(context).colorScheme.primary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  "My QR Code",
                  style: Theme.of(context).textTheme.headlineSmall!.merge(
                        TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      ),
                ),
              ),
              Transform.rotate(
                angle: math.pi / 2,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: SvgPicture.asset('assets/icons/arrow3.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.background,
                          BlendMode.srcIn)),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 15),
          child: QRView(
            data: Uint8List.fromList([1, 2, 3, 4]),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            "AaryaPay Nepali",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .merge(const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        Text("Scan QR Code to receive Money",
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: TextAlign.center)
      ]),
    );
  }
}
