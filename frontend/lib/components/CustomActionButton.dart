import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton({
    Key? key,
    this.label,
    this.textTheme,
    this.onClick,
    this.width,
    this.height,
    this.borderRadius,
    this.actionLogo,
    this.color,
    this.margin,
  }) : super(key: key);
  final String? label;
  final Function()? onClick;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? margin;
  final Widget? actionLogo;
  final TextStyle? textTheme;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onClick,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width ?? size.width * 0.6,
        alignment: Alignment.center,
        height: height ?? 50,
        decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.primary,
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 50))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            actionLogo ?? Container(),
            Text(
              label ?? "LOGIN",
              style: textTheme ??
                  Theme.of(context).textTheme.titleLarge!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.background)),
            ),
          ],
        ),
      ),
    );
  }
}
