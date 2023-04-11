import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton(
      {Key? key,
      this.label,
      this.onClick,
      this.width,
      this.height,
      this.borderRadius})
      : super(key: key);
  final String? label;
  final Function()? onClick;
  final double? width;
  final double? height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onClick,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width ?? size.width * 0.6,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
        height: height ?? 50,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 50))),
        child: Text(
          label ?? "LOGIN",
          style: Theme.of(context).textTheme.titleLarge!.merge(
              TextStyle(color: Theme.of(context).colorScheme.background)),
        ),
      ),
    );
  }
}
