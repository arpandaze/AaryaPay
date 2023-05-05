
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomArrowedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CustomArrowedButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(50),
            // border: Border.all(
            //   color: colorType,
            // ),
          ),
          child: SvgPicture.asset(
            "assets/icons/arrow.svg",
            width: 20,
            height: 20,
          )),
    );
  }
}
