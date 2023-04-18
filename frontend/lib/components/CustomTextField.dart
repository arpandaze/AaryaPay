import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String placeHolder;
  final bool isPassword;
  final double height;
  final ValueChanged? onChanged;
  final double? width;
  final TextEditingController? messageController;
  final String? error;
  final Widget? counter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? outlined;
  final String? label;
  final String? topText;
  final bool? enableTopText;
  final TextStyle? placeHolderSize;

  const CustomTextField({
    Key? key,
    this.padding = const EdgeInsets.all(0),
    this.placeHolder = "",
    this.width,
    this.height = 20,
    this.isPassword = false,
    this.margin = const EdgeInsets.all(0),
    this.onChanged,
    this.messageController,
    this.error,
    this.counter,
    this.prefixIcon,
    this.suffixIcon,
    this.outlined = false,
    this.label,
    this.topText = "",
    this.placeHolderSize,
    this.enableTopText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: padding,
      width: width,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
              visible: enableTopText!,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  topText!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .merge(const TextStyle(fontWeight: FontWeight.w700)),
                ),
              )),
          TextField(
              style: Theme.of(context).textTheme.bodySmall,
              controller: messageController,
              obscureText: isPassword,
              onChanged: onChanged,
              decoration: InputDecoration(
                  // labelText: label ?? " ",
                  icon: prefixIcon,
                  suffixIcon: isPassword
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset("assets/icons/invisible.svg",
                            width: 10,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.primary,
                                BlendMode.srcIn),
                          ),
                        )
                      : suffixIcon,
                  // errorText: error,
                  counter: counter,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: !outlined!
                      ? UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.0))
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
                              width: 1.0)),
                  hintText: placeHolder,
                  hintStyle: placeHolderSize ??
                      Theme.of(context).textTheme.titleSmall!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onTertiary),
                          ),
                  focusedBorder: !outlined!
                      ? UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          ),
                        )
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2.0)))),
        ],
      ),
    );
  }
}
