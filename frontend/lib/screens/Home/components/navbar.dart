import 'dart:developer';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.25,
            child: ImageIcon(
              AssetImage(
                "assets/icons/home.png",
              ),
              size: 30,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          Container(
              width: size.width * 0.25,
              child: ImageIcon(
                AssetImage("assets/icons/statements.png"),
                size: 30,
                color: Theme.of(context).colorScheme.onBackground,
              )),
          Container(
              width: size.width * 0.25,
              child: ImageIcon(
                AssetImage("assets/icons/payments.png"),
                size: 27,
                color: Theme.of(context).colorScheme.onBackground,
              )),
          Container(
              width: size.width * 0.25,
              child: ImageIcon(
                AssetImage("assets/icons/settings.png"),
                size: 30,
                color: Theme.of(context).colorScheme.onBackground,
              )),
        ],
      ),
    );
  }
}
