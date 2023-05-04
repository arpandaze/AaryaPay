import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String placeHolder;
  final bool isPassword;
  final double? height;
  final ValueChanged? onChanged;
  final double? width;
  final TextEditingController? messageController;
  final String? error;
  final Widget? counter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool outlined;
  final String? label;
  final String? topText;
  final bool? enableTopText;
  final TextStyle? placeHolderSize;

  const CustomTextField({
    Key? key,
    this.padding = const EdgeInsets.all(0),
    this.placeHolder = "",
    this.width,
    this.height,
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;

  void togglePassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  void initState() {
    showPassword = widget.isPassword;
  }

  Widget build(BuildContext context) {
    return widget.height != null
        ? Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: widget.enableTopText!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      widget.topText!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .merge(const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                TextField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  controller: widget.messageController,
                  obscureText: widget.isPassword && showPassword,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    // labelText: label ?? " ",
                    icon: widget.prefixIcon,
                    suffixIconConstraints:
                        const BoxConstraints(maxWidth: 25, maxHeight: 25),
                    suffixIcon: widget.isPassword
                        ? GestureDetector(
                            onTap: () => togglePassword(),
                            child: SvgPicture.asset(
                              "assets/icons/invisible.svg",
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn),
                            ),
                          )
                        : widget.suffixIcon,
                    // errorText: error,
                    counter: widget.counter,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    enabledBorder: !widget.outlined
                        ? UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.0))
                        : OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(50, 0, 0, 0), width: 1.0),
                          ),
                    hintText: widget.placeHolder,
                    hintStyle: widget.placeHolderSize ??
                        Theme.of(context).textTheme.titleSmall!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onTertiary),
                            ),
                    focusedBorder: !widget.outlined
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
                                width: 2.0),
                          ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: widget.width,
            margin: widget.margin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: widget.enableTopText!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      widget.topText!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .merge(const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
                TextField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  controller: widget.messageController,
                  obscureText: widget.isPassword && showPassword,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    // labelText: label ?? " ",
                    icon: widget.prefixIcon,
                    suffixIconConstraints:
                        const BoxConstraints(maxWidth: 25, maxHeight: 25),
                    suffixIcon: widget.isPassword
                        ? GestureDetector(
                            onTap: () => togglePassword(),
                            child: SvgPicture.asset(
                              "assets/icons/invisible.svg",
                              colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn),
                            ),
                          )
                        : widget.suffixIcon,
                    // errorText: error,
                    counter: widget.counter,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: widget.outlined ? 10 : 5),
                    enabledBorder: !widget.outlined
                        ? UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.0))
                        : OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(50, 0, 0, 0), width: 1.0),
                          ),
                    hintText: widget.placeHolder,
                    hintStyle: widget.placeHolderSize ??
                        Theme.of(context).textTheme.titleSmall!.merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onTertiary),
                            ),
                    focusedBorder: !widget.outlined
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
                                width: 2.0),
                          ),
                  ),
                ),
              ],
            ),
          );
  }
}
