import 'dart:convert';

import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_svg/svg.dart';

class CustomStatusButton extends StatelessWidget {
  const CustomStatusButton(
      {Key? key, required this.widget, required this.label})
      : super(key: key);
  final Widget widget;
  final String label;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      // onTap: print("lol"),
      child: Container(
        padding: EdgeInsets.all(5),
        width: size.width * 0.19,
        height: size.height * 0.04,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // SvgPicture.asset(
          //   "assets/icons/sync.svg",
          //   height: 11,
          //   width: 11,
          // ),
          widget,
          Text(
            label,
            style: textTheme.bodySmall,
          )
        ]),
      ),
    );
  }
}
