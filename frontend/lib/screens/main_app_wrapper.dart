import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Payments/payments.dart';
import 'package:aaryapay/screens/QrScan/qrscan_screen.dart';
import 'package:aaryapay/screens/Settings/settings.dart';
import 'package:aaryapay/screens/TransactionHistory/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/components/topbar.dart';
import 'package:aaryapay/components/navbar.dart';
import 'package:flutter/services.dart';

class MainAppWrapper extends StatelessWidget {
  const MainAppWrapper({Key? key, this.children}) : super(key: key);
  final Widget? children;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: true,
      left: true,
      right: true,
      bottom: true,
      child: Container(
        width: double.infinity,
        height: size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          gradient: const SweepGradient(
            colors: [Color(0xff274233), Color(0xff39a669)],
            stops: [0, 1],
            center: Alignment.topRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: const NavBar(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: TopBar(size: size),
          ),
          body: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              color: Color(0xfff4f6f4),
            ),
            child: Navigator(
              key: Utils.mainListNav,
              initialRoute: '/app/home',
              onGenerateRoute: (RouteSettings settings) {
                Widget page;
                switch (settings.name) {
                  case '/app/home':
                    page = const HomeScreen();
                    break;
                  case '/app/payments':
                    page = const Payments();
                    break;
                  case '/app/transactions':
                    page = const TransactionHistory();
                    break;
                  case '/app/settings':
                    page = const Settings();
                    break;
                  case '/app/qrscan':
                    page = const QrScanScreen();
                    break;
                  default:
                    page = const HomeScreen();
                    break;
                }

                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => page,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final curve = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    );

                    animation.addStatusListener(
                      (status) {
                        if (status == AnimationStatus.completed) {
                          HapticFeedback.selectionClick();
                        }
                      },
                    );

                    return Stack(
                      children: [
                        FadeTransition(
                          opacity: animation.drive(
                            Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).animate(curve),
                          child: child,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
