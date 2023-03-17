import 'package:aaryapay/screens/Login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Login/login_screen.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      width: size.width,
      padding: EdgeInsets.only(left: 10),
      height: size.height * 0.15,
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
                  style: Theme.of(context).textTheme.bodyLarge!.merge(TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        "\$18,5333.45",
                        style: Theme.of(context).textTheme.displaySmall!.merge(
                            TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: ImageIcon(
                        AssetImage("assets/icons/hide.png"),
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
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
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            LoginScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ),
                    // child: CircleAvatar(
                    //   backgroundImage: AssetImage("assets/images/pfp.jpeg"),
                    //   // radius: ,
                    // ),
                    child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                                image: AssetImage("assets/images/pfp.jpeg")))),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 12,
                    height: 12,
                    // alignment: Alignment(-0.1, -0.1),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
