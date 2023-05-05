import 'package:aaryapay/screens/Home/components/quick_payment.dart';
import 'package:aaryapay/screens/Home/components/recent_card.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Home/components/favourites.dart';
import 'package:aaryapay/screens/Home/components/last_synchronized.dart';

Future<void> _refresh() async {}
class Midsection extends StatelessWidget {
  const Midsection({
    super.key,
    required this.size,
  });
  final Size size;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Favourites(),
            const QuickPayment(),
            const LastSynchronized(),
            RecentCard(size: size),
          ],
        ),
      ),
    );
  }
}
