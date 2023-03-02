import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     border: Border.all(
      //         color: Theme.of(context).colorScheme.primary)),
      width: size.width,
      height: size.height / 10,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: ImageIcon(
                    const AssetImage("assets/icons/menu-rounded.png"),
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 30,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("HOME",
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20)),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/pfp.jpeg"),
                // radius: ,
              ),
            ),
          ]),
    );
  }
}
