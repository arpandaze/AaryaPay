import 'package:aaryapay/screens/Home/components/recent_card.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Home/components/favourites.dart';
import 'package:aaryapay/screens/Home/components/last_synchronized.dart';


class Midsection extends StatelessWidget {
  Midsection({
    super.key,
    required this.size,
  });
  final Size size;
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      // height: size.height * 0.7,
      child: Container(
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Favourites(),
                LastSynchronized(),
                RecentCard(size: size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
