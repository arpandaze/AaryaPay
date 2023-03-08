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
      margin: EdgeInsets.only(left: 20),
      height: size.height / 10,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    child: Text(
                  "Balance",
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "\$18,5333",
                        style: Theme.of(context).textTheme.labelLarge!.merge(
                            TextStyle(
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                    ),
                    Container(
                      child: ImageIcon(AssetImage("assets/icons/hide.png")),
                    )
                  ],
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
