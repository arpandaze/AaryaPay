import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Payments/payments.dart';
import 'package:aaryapay/screens/QrScan/qrscan_screen.dart';
import 'package:aaryapay/screens/Settings/settings.dart';
import 'package:aaryapay/screens/TransactionHistory/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    Key? key,
    required this.size,
    required this.pageName,
  }) : super(key: key);
  final Size size;
  final String pageName;
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.none,
      // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      // padding: const EdgeInsets.only(top: 6, left: 15, right: 15),
      // margin: const EdgeInsets.only(top: 20),
      alignment: const Alignment(-0.5, 0.5),

      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[4],
        color: Theme.of(context).colorScheme.background,
      ),
      // border: Border.all(color: Colors.black)),
      width: size.width,
      height: size.height * 0.08,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const HomeScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background)),
                      width: size.width * 0.20,
                      // height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            pageName == "home"
                                ? "assets/icons/home-fill.svg"
                                : "assets/icons/home.svg",
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            "Home",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: pageName == "home"
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const Payments(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background)),
                      width: size.width * 0.20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            pageName == "payments"
                                ? "assets/icons/wallet-fill.svg"
                                : "assets/icons/payments.svg",
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            "Payments",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: pageName == "payments"
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const TransactionHistory(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ),
                    child: Container(

                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background)),
                      width: size.width * 0.20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            pageName == "statements"
                                ? "assets/icons/statements-fill.svg"
                                : "assets/icons/statements.svg",
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            "Statements",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: pageName == "statements"
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const Settings(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background)),
                      width: size.width * 0.20,
                      // height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SvgPicture.asset("assets/icons/home.svg"),
                          SvgPicture.asset(
                            (pageName == "settings")
                                ? "assets/icons/gear-fill.svg"
                                : "assets/icons/settings.svg",
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            "Settings",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: pageName == "settings"
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            // height: 100,
            // padding: EdgeInsets.symmetric(horizontal: 20),
            child: Positioned(
              bottom: 30,
              left: size.width / 2 - 30,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const QrScanScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      boxShadow: kElevationToShadow[4],
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(50),
                          top: Radius.circular(50))),
                  child: SvgPicture.asset(
                    "assets/icons/qrcode.svg",
                    width: 25,
                    height: 25,
                    color: colorScheme.background,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
