import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuickPayment extends StatelessWidget {
  const QuickPayment({Key? key}) : super(key: key);

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
      height: size.height * 0.18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Send Money",
            style: textTheme.titleMedium,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  width: size.width * 0.65,
                  placeHolder: "E-mail Address",
                  outlined: true,
                ),
                CustomActionButton(
                  width: size.width * 0.20,
                  height: 40,
                  actionLogo: SvgPicture.asset(
                    "assets/icons/send.svg",
                    width: 12,
                    colorFilter: ColorFilter.mode(
                      colorScheme.background,
                      BlendMode.srcIn,
                    ),
                  ),
                  textTheme: textTheme.bodyLarge!.merge(
                    TextStyle(
                      color: colorScheme.background,
                    ),
                  ),
                  label: "Send",
                  borderRadius: 10,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
