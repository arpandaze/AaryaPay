import 'package:flutter/material.dart';
import 'package:aaryapay/components/topbar.dart';
import 'package:aaryapay/components/navbar.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key, this.children}) : super(key: key);
  final Widget? children;
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
                children: [TopBar(size: size), children ?? Container()],
              ),
            ),
            Positioned(
              bottom: 10,
              child: NavBar(
                size: size,
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
