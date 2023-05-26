import 'package:aaryapay/screens/Send/components/numpad_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class midMatrix extends StatelessWidget {
  const midMatrix({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // width: size.width * 0.5,
              // height: size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const NumPadButton(text: 'AC'),
                      NumPadButton(
                        icon: SvgPicture.asset("assets/icons/erase.svg",
                            height: 15,
                            width: 15,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.background,
                                BlendMode.srcIn)),
                        text: "erase",
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const NumPadButton(text: '÷'),
                      // NumPadButton(text: 'X'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      NumPadButton(text: '7'),
                      NumPadButton(text: '8'),
                      NumPadButton(text: '9'),
                      // NumPadButton(text: '-'),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          NumPadButton(text: '4'),
                          NumPadButton(text: '5'),
                          NumPadButton(text: '6'),
                          // NumPadButton(text: '-'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          NumPadButton(text: '1'),
                          NumPadButton(text: '2'),
                          NumPadButton(text: '3'),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      NumPadButton(
                        text: '0',
                        width: 140,
                      ),
                      NumPadButton(text: '.'),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                NumPadButton(
                  text: 'X',
                ),
                NumPadButton(
                  text: '-',
                ),
                NumPadButton(
                  text: '+',
                  height: 130,
                ),
                NumPadButton(text: '='),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
