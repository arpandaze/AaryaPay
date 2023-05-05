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
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: size.width,
      height: size.height * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Last Synchronization",
            style: textTheme.bodyLarge!
                .merge(TextStyle(color: colorScheme.outline)),
          ),
          Text(
            "12/04/2023 5:45 pm",
            style: textTheme.bodyMedium!
                .merge(TextStyle(color: colorScheme.outline)),
          ),
          CustomStatusButton(
            width: size.width * 0.20,
            height: size.height * 0.04,
            label: "Sync",
            textStyle: textTheme.labelSmall!.merge(const TextStyle(height: 0)),
            widget: SvgPicture.asset(
              "assets/icons/sync.svg",
              height: 14,
              width: 14,
            ),
          ),
        ],
      ),
    );
  }
}
