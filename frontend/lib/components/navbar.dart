import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/QrScan/qrscan_screen.dart';
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
    return Container(
      clipBehavior: Clip.none,
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
                              color: Theme.of(context).colorScheme.background)),
                      width: size.width * 0.20,
                      // height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            currentPage == "home"
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
                                color: Theme.of(context).colorScheme.primary),
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
                              color: Theme.of(context).colorScheme.background)),
                      width: size.width * 0.20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            currentPage == "payments"
                                ? "assets/icons/wallet-fill.svg"
                                : "assets/icons/wallet.svg",
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
                    onTap: () {
                      if (currentPage != "transactions") {
                        Utils.mainListNav.currentState!
                            .pushReplacementNamed("/app/transactions");
                      }
                      switchPage("transactions");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background)),
                      width: size.width * 0.20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            currentPage == "transactions"
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
                                color: Theme.of(context).colorScheme.primary),
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
                              color: Theme.of(context).colorScheme.background)),
                      width: size.width * 0.20,
                      // height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SvgPicture.asset("assets/icons/home.svg"),
                          SvgPicture.asset(
                            currentPage == "settings"
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
          Positioned(
            bottom: 30,
            left: size.width / 2 - 30,
            child: GestureDetector(
              onTap: () {
                Utils.mainAppNav.currentState!.pushNamed("/app/qrscan");
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: kElevationToShadow[4],
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(50),
                    top: Radius.circular(50),
                  ),
                ),
                child: SvgPicture.asset(
                  "assets/icons/qrcode.svg",
                  width: 25,
                  height: 25,
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
    );
  }
}
