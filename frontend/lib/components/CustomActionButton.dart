import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton({Key? key, this.label, this.onClick})
      : super(key: key);
  final String? label;
  final Function()? onClick;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // width: 100,
        margin: EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
        height: 50,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Text(
          label ?? "LOGIN",
          style: Theme.of(context).textTheme.titleLarge!.merge(
              TextStyle(color: Theme.of(context).colorScheme.background)),
        ),
      ),
    );
  }
}
