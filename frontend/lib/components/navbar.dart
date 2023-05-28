import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String currentPage = "home";

  void switchPage(String pageName) {
    setState(() => {currentPage = pageName});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color navColor = Color(0xff2e6b4a);
    return Container(
      color: const Color(0xfff4f6fa),
      child: Container(
        clipBehavior: Clip.none,
        alignment: const Alignment(-0.5, 0.5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: kElevationToShadow[4],
          color: Theme.of(context).colorScheme.background,
        ),
        // border: Border.all(color: Colors.black)),
        width: size.width,
        height: size.height * 0.095,
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
                      onTap: () {
                        if (currentPage != "home") {
                          Utils.mainListNav.currentState!
                              .pushReplacementNamed("/app/home");
                        }

                        switchPage("home");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        width: size.width * 0.20,
                        // height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/home-fill.svg",
                              width: 25,
                              height: 25,
                              colorFilter: ColorFilter.mode(
                                  currentPage == "home"
                                      ? navColor
                                      : Theme.of(context).colorScheme.outline,
                                  BlendMode.srcIn),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Home",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: currentPage == "home"
                                      ? navColor
                                      : Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (currentPage != "payments") {
                          Utils.mainListNav.currentState!
                              .pushReplacementNamed("/app/payments");
                        }
                        switchPage("payments");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        width: size.width * 0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/wallet-fill.svg",
                              width: 25,
                              height: 25,
                              colorFilter: ColorFilter.mode(
                                  currentPage == "payments"
                                      ? navColor
                                      : Theme.of(context).colorScheme.outline,
                                  BlendMode.srcIn),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Payments",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: currentPage == "payments"
                                      ? navColor
                                      : Theme.of(context).colorScheme.outline,
                                ),
                              ),
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
                      onTap: () {
                        if (currentPage != "transactions") {
                          Utils.mainListNav.currentState!
                              .pushReplacementNamed("/app/transactions");
                        }
                        switchPage("transactions");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                        ),
                        width: size.width * 0.20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/statements-fill.svg",
                              width: 25,
                              height: 25,
                              colorFilter: ColorFilter.mode(
                                  currentPage == "transactions"
                                      ? navColor
                                      : Theme.of(context).colorScheme.outline,
                                  BlendMode.srcIn),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Statements",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: currentPage == "transaction"
                                      ? navColor
                                      : Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (currentPage != "settings") {
                          Utils.mainListNav.currentState!
                              .pushReplacementNamed("/app/settings");
                        }
                        switchPage("settings");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        width: size.width * 0.20,
                        // height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/gear-fill.svg",
                              width: 25,
                              height: 25,
                              colorFilter: ColorFilter.mode(
                                  currentPage == "settings"
                                      ? navColor
                                      : Theme.of(context).colorScheme.outline,
                                  BlendMode.srcIn),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: currentPage == "settings"
                                      ? navColor
                                      : Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 50,
              left: size.width / 2 - 30,
              child: GestureDetector(
                onTap: () {
                  Utils.mainAppNav.currentState!.pushNamed("/app/qrscan");
                },
                child: Container(
                  width: 65,
                  height: 65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: kElevationToShadow[4],
                    color: navColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(50),
                      top: Radius.circular(50),
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/qrcode.svg",
                    width: 28,
                    height: 28,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.background,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
