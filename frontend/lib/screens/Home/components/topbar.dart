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
                    size: 25,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("HOME",
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ],
            ),
            Stack(
              children: [
             
                Container(
                  margin: EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20)),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/pfp.jpeg"),
                    // radius: ,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    alignment: Alignment(-0.1, -0.1),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
