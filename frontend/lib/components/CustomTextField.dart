import 'package:flutter/material.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: padding,
      width: width,
      margin: margin,
      child: TextField(
        style: Theme.of(context).textTheme.bodySmall,
        controller: messageController,
        obscureText: isPassword,
        onChanged: onChanged,
        decoration: InputDecoration(
            icon: prefixIcon,
            suffixIcon: suffixIcon,
            // errorText: error,
            counter: counter,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 1.0)),
            hintText: placeHolder,
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2.0))),
      ),
    );
  }
}
