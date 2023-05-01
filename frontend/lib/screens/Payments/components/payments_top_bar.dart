import 'package:flutter/material.dart';

class PaymentsTopBar extends StatelessWidget {
  const PaymentsTopBar({Key? key, this.items_length}) : super(key: key);
  final int? items_length;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(10),
      width: size.width * 0.9,
      height: size.height * 0.09,
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(50, 0, 0, 0)),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pending",
                  style: textTheme.bodyMedium,
                ),
                Text(
                  "${items_length ?? 3}",
                  style: textTheme.headlineMedium,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Total Pending Amount", style: textTheme.bodyMedium),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      child: Text(("Rs."), style: textTheme.bodyLarge),
                    ),
                    Text("350", style: textTheme.headlineMedium)
                  ],
                )
              ],
            )
          ]),
    );
  }
}
