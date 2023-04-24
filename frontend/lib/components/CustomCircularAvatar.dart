import 'package:flutter/material.dart';

class CustomCircularAvatar extends StatelessWidget {
  const CustomCircularAvatar({Key? key, required this.imageSrc, this.size})
      : super(key: key);
  final AssetImage imageSrc;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: const BorderRadius.all(Radius.circular(50))),
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(5),
      child: CircleAvatar(
        radius: size ?? 25,
        backgroundImage: imageSrc,
        // color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
