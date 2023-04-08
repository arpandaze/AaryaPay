import 'dart:convert';

import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class Favourites extends StatelessWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
      child: Container(
        width: size.width,
        height: size.height * 0.16,
        decoration: BoxDecoration(
          border: Border(
            // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
            bottom: BorderSide(width: 2.0, color: colorScheme.onPrimary),
          ),
        ),
        // height: size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Favourites",
                    style: textTheme.titleMedium,
                  ),
                  CustomStatusButton(
                    label: "Offline",
                    widget: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                  CustomCircularAvatar(
                      imageSrc: AssetImage("assets/images/pfp.jpeg")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
