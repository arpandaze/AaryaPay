import 'dart:math' as math;
import 'package:aaryapay/screens/QrScan/components/my_qr_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomQrBar extends StatelessWidget {
  const BottomQrBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: size.width,
          height: 60,
          // color: Theme.of(context).colorScheme.primary,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  "My QR Code",
                  style: Theme.of(context).textTheme.headlineSmall!.merge(
                        const TextStyle(color: Colors.white),
                      ),
                ),
              ),
              Container(
                child: Transform.rotate(
                  angle: -math.pi / 2,
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        builder: (BuildContext context) {
                          return MyQRCode(size: size);
                        },
                      );
                    },
                    icon: SvgPicture.asset('assets/icons/arrow3.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn)),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
