import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

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
      // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      // padding: const EdgeInsets.only(top: 6, left: 15, right: 15),
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment(-0.5, 0.5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      // border: Border.all(color: Colors.black)),
      width: size.width,
      height: size.height * 0.08,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.black54)),
                    width: size.width * 0.20,
                    // height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LineIcons.desktop,
                          size: 30,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.black54)),
                    width: size.width * 0.20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.rupeeSign,
                          size: 20,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          "Payments",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.black54)),
                    width: size.width * 0.20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.braille,
                          size: 20,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          "Wallet",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.black54)),
                    width: size.width * 0.20,
                    // height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.gear,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Text(
                          "Settings",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            // height: 100,
            // padding: EdgeInsets.symmetric(horizontal: 20),
            child: Positioned(
                bottom: -25,
                left: size.width / 2 - 30,
                child: Container(
                  width: 60,
                  height: 100,
                  alignment: const Alignment(0, -0.3),
                  decoration: BoxDecoration(
                      boxShadow: kElevationToShadow[4],
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10))),
                  child: ImageIcon(
                    const AssetImage("assets/icons/scan.png"),
                    size: 30,
                    color: Theme.of(context).colorScheme.background,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
