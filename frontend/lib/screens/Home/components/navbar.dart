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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // alignment: Alignment(-0.5, 0.5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      // border: Border.all(color: Colors.black)),
      width: size.width,
      height: size.height * 0.05,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.black54)),
                    width: size.width * 0.20,
                    child: ImageIcon(
                      const AssetImage(
                        "assets/icons/home.png",
                      ),
                      size: 30,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.black54)),
                      width: size.width * 0.20,
                      child: ImageIcon(
                        const AssetImage("assets/icons/statements.png"),
                        size: 30,
                        color: Theme.of(context).colorScheme.onBackground,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.black54)),
                      width: size.width * 0.20,
                      child: ImageIcon(
                        const AssetImage("assets/icons/payments.png"),
                        size: 27,
                        color: Theme.of(context).colorScheme.onBackground,
                      )),
                  SizedBox(
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.black54)),
                      width: size.width * 0.20,
                      // height: double.infinity,
                      child: ImageIcon(
                        const AssetImage("assets/icons/settings.png"),
                        size: 30,
                        color: Theme.of(context).colorScheme.onBackground,
                      )),
                ],
              ),
              
            ],
          ),
          Container(
            // height: 100,
            // padding: EdgeInsets.symmetric(horizontal: 20),
            child: Positioned(
                bottom: -20,
                left: size.width / 2 - 35,
                child: Container(
                  width: 60,
                  height: 70,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      boxShadow: kElevationToShadow[2],
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10))),
                  child: ImageIcon(
                    const AssetImage("assets/icons/scan.png"),
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )),
          ),
          
        ],
      ),
    );
  }
}
