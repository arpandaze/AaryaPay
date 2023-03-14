import 'package:aaryapay/screens/Home/components/recent_card.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Home/components/send_money_card.dart';


class Midsection extends StatelessWidget {
  const Midsection({
    super.key,
    required this.size,
  });
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.9,
      height: size.height * 0.8,
      child: Container(
        clipBehavior: Clip.none,
        // decoration: BoxDecoration(
        //     border:
        //         Border.all(color: Theme.of(context).colorScheme.onBackground)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SendMoneyCard(),
              
              RecentCard(size: size),
            ],
          ),
        ),
      ),
    );
  }
}
