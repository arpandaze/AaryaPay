import 'package:flutter/material.dart';

class RecentTransfer extends StatelessWidget {
  const RecentTransfer({Key? key, required this.imageSrc, required this.label})
      : super(key: key);

  final AssetImage imageSrc;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: CircleAvatar(
        backgroundImage: imageSrc,
        // color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
