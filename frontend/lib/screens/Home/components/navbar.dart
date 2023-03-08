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
      clipBehavior: Clip.none,
      // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      width: size.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
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
          Positioned(
              bottom: 10,
              left: size.width / 2 - 22,
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(50)),
                child: ImageIcon(
                  AssetImage("assets/icons/scan.png"),
                  size: 35,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
        ],
      ),
    );
  }
}
