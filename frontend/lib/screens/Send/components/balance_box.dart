import 'dart:ffi' as ffi;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BalanceBox extends StatelessWidget {
  final String balance;
  const BalanceBox({
    required this.balance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              "Balance",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(
                      'assets/icons/rupee.svg',
                      width: 23,
                      height: 23,
                      colorFilter: const ColorFilter.mode(
                          Color(0xff274233), BlendMode.srcIn),
                    ),
                  ),
                  Text(
                    balance,
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Text(
                        "Offline",
                        style: Theme.of(context).textTheme.titleSmall!,
                      ),
                    ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
