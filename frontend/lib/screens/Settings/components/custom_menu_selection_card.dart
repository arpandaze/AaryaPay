import 'package:flutter/material.dart';

class CustomMenuSelectionCard extends StatelessWidget {
  const CustomMenuSelectionCard(
      {Key? key,
      required this.icon,
      required this.label,
      required this.trailingWidget,
      this.onTap})
      : super(key: key);
  final Widget icon;
  final String label;
  final Widget trailingWidget;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap ?? () => {},
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(15),
        width: size.width * 0.9,
        height: size.height * 0.07,
        decoration: BoxDecoration(
            border: Border.all(color: colorScheme.surface),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    icon,
                    Container(
                        margin: const EdgeInsets.only(left: 15),
                        child: Text(
                          label,
                          style: textTheme.bodyLarge,
                        ))
                  ],
                ),
              ),
              trailingWidget
            ]),
      ),
    );
  }
}
