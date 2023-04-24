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
      child: Container(
        width: double.infinity,
        height: size.height,
        child: Scaffold(
          bottomNavigationBar: NavBar(
            pageName: pageName,
            size: size,
          ),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: TopBar(size: size),
          ),
          body: children ?? Container(),
        ),
      ),
    );
  }
}
