import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomAddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  CustomAddButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(50),
            // border: Border.all(
            //   color: colorType,
            // ),
          ),
          child: ImageIcon(
            AssetImage("assets/icons/plus.png"),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
