import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Payments/payments.dart';
import 'package:aaryapay/screens/Settings/settings.dart';
import 'package:aaryapay/screens/TransactionHistory/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/components/topbar.dart';
import 'package:aaryapay/components/navbar.dart';

class MainAppWrapper extends StatelessWidget {
  const MainAppWrapper({Key? key, this.children}) : super(key: key);
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
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          bottomNavigationBar: const NavBar(),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: TopBar(size: size),
          ),
          body: Navigator(
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
                default:
                  page = const HomeScreen();
                  break;
              }

              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => page,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
