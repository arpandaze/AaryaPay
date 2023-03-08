import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:aaryapay/components/iconed_operations.dart';
import 'dart:developer';

class FrequentOperationsCard extends StatelessWidget {
  const FrequentOperationsCard({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5),
        //     border: Border.all(color: Theme.of(context).colorScheme.onPrimary)),
        padding: const EdgeInsets.only(top: 10),
        height: 80,
        width: double.infinity,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconedOperations(
              imageSrc: AssetImage("assets/icons/load-money.png"),
              label: "Load Money"),
          IconedOperations(
              imageSrc: AssetImage("assets/icons/send-money.png"),
              label: "Send Money"),
          IconedOperations(
              imageSrc: AssetImage("assets/icons/topup.png"), label: "Topup"),
          IconedOperations(
              imageSrc: AssetImage("assets/icons/bank-transfer.png"),
              label: "Bank Transfer"),
        ]),
      ),
    );
  }
}
