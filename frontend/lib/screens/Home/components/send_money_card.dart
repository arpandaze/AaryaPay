import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';

class SendMoneyCard extends StatelessWidget {
  const SendMoneyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        // decoration: BoxDecoration(
        //     // boxShadow: kElevationToShadow[1],
        //     borderRadius: BorderRadius.circular(5),
        //     border: Border.all(color: Theme.of(context).colorScheme.onPrimary)),
        padding: const EdgeInsets.only(top: 10),
        // height: 80,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Send Money",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Container(
                          child: Row(children: [
                        Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child:
                                Image.asset("assets/icons/money-transfer.png")),
                        Container(
                          // clipBehavior: Clip.none,
                          height: 60,
                          // decoration: BoxDecoration(
                          //   color: Theme.of(context).colorScheme.onPrimary,
                          //   borderRadius: BorderRadius.circular(50),
                          // ),
                          padding: const EdgeInsets.fromLTRB(10, 0, 55, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Pay From your Phone",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  "For the things you love",
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              ]),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          child: Text("Send",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .merge(TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary))),
                        )
                      ])),
                    ],
                  )),
            ]),
      ),
    );
  }
}
