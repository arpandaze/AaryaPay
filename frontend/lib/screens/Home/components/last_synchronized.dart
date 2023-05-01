import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LastSynchronized extends StatelessWidget {
  const LastSynchronized({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.onPrimary),
        ),
      ),
      width: size.width,
      height: size.height * 0.14,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last Synchronization",
              style: textTheme.titleMedium,
            ),
            Text(
              "12/04/2023   5:45 pm",
              style: textTheme.titleSmall!
                  .merge(TextStyle(color: colorScheme.surface)),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomStatusButton(
              widget: SvgPicture.asset(
                "assets/icons/sync.svg",
                height: 14,
                width: 14,
              ),
              label: "Sync",
            ),
            Container(
              width: size.width * 0.20,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Pending",
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium!.merge(
                  TextStyle(
                    color: colorScheme.background,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
