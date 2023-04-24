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
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 2.0, color: colorScheme.onPrimary),
      )),
      width: size.width,
      height: size.height * 0.11,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomStatusButton(
                      widget: SvgPicture.asset(
                        "assets/icons/sync.svg",
                        height: 11,
                        width: 11,
                      ),
                      label: "Sync"),
                  Container(
                      width: size.width * 0.18,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Pending",
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall!.merge(
                          TextStyle(color: colorScheme.background),
                        ),
                      )),
                ],
              )
            ]),
      ),
    );
  }
}
