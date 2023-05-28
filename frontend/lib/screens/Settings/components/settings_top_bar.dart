import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class SettingsTopBar extends StatelessWidget {
  const SettingsTopBar({
    Key? key,
    required this.label,
  }) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Utils.mainAppNav.currentState!.popUntil(
                  ModalRoute.withName("/app"),
                );
              },
              icon: Transform.rotate(
                angle: -math.pi,
                child: SvgPicture.asset(
                  "assets/icons/arrow2.svg",
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Text(label, style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
        ],
      ),
    );
  }
}
