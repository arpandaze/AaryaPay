import 'package:flutter/material.dart';
import 'package:aaryapay/components/topbar.dart';
import 'package:aaryapay/components/navbar.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key, this.children, required this.pageName})
      : super(key: key);
  final Widget? children;
  final String pageName;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: true,
      bottom: true,
      child: SizedBox(
        width: double.infinity,
        height: size.height,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topLeft,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(size: size),
                  Flexible(
                    child: children ?? Container(),
                  ),
                  Positioned(
                    bottom: 0,
                    child: NavBar(
                      pageName: pageName,
                      size: size,
                    ),
                  )
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
