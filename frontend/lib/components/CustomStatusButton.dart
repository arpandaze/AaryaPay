import 'package:flutter/material.dart';

class CustomStatusButton extends StatelessWidget {
  const CustomStatusButton({
    Key? key,
    required this.widget,
    this.label,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
    this.color,
    this.onTap,
  }) : super(key: key);

  final Widget widget;
  final double? width;
  final double? height;
  final String? label;
  final double? borderRadius;
  final TextStyle? textStyle;
  final Color? color;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        width: width ?? size.width * 0.20,
        height: height ?? size.height * 0.04,
        decoration: BoxDecoration(
            border: Border.all(color: color ?? Colors.black26),
            borderRadius:
                BorderRadius.all(Radius.circular(borderRadius ?? 10))),
        child: Row(
          mainAxisAlignment: label != null
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   "assets/icons/sync.svg",
            //   height: 11,
            //   width: 11,
            // ),
            widget,
            label != null
                ? Text(
                    label ?? "",
                    style: textStyle ?? textTheme.titleSmall,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
