import 'package:flutter/material.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.centerLeft,
        child: Column(children: [
          Text(
            "Recent Transfer",
            style: Theme.of(context).textTheme.headlineMedium,
          )
        ]),
      ),
    );
  }
}
