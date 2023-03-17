import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';

class SendMoneyCard extends StatelessWidget {
  const SendMoneyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: EdgeInsets.only(left: 10, bottom: 12),
              child: Text(
                "Send Money",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Material(
              // elevation: 1,
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    // boxShadow: kElevationToShadow[1]
                    // borderRadius: BorderRadius.circular(5),
                  ),
                  margin: EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(21),
                  child: Column(
                    children: [
                      Row(children: [
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
                   
                          padding: const EdgeInsets.fromLTRB(10, 0, 55, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Pay From your Phone",
                                  style:
                                      Theme.of(context).textTheme.bodyLarge,
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
                                color: Theme.of(context).colorScheme.primary,
                                boxShadow: kElevationToShadow[2],
                                borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                            // child: Text("Send",
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .headlineSmall!
                            //         .merge(TextStyle(
                            //             color: Theme.of(context)
                            //                 .colorScheme
                            //                 .primary))),
                            child: Icon(
                              Icons.chevron_right_sharp,
                              color: Theme.of(context).colorScheme.surface,
                            ))
                      ]),
                    ],
                  )),
            ),
          ]),
    );
  }
}
