import 'dart:ffi' as ffi;
import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:aaryapay/screens/Send/bloc/send_money_bloc.dart';
import 'package:aaryapay/screens/Send/components/balance_box.dart';
import 'package:aaryapay/screens/Send/components/numpad_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMoney extends StatelessWidget {
  const SendMoney({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: BlocProvider(
            create: (context) => SendMoneyBloc(),
            child: body(size, context),
          ),
        ));
  }

  Widget body(Size size, BuildContext context) {
    return BlocBuilder<SendMoneyBloc, SendMoneyState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.pop(context),
                            child: const Icon(FontAwesomeIcons.arrowLeftLong)),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(15),
                        child: Text("Send Money",
                            style: Theme.of(context).textTheme.headlineMedium!),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const BalanceBox(),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.fromLTRB(50, 30, 50, 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      width: 2.0, color: Theme.of(context).colorScheme.outline),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/rupee.svg',
                    width: 30,
                    height: 30,
                    colorFilter: const ColorFilter.mode(
                        Color(0xff274233), BlendMode.srcIn),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text("${state.amount}",
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .merge(TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)))),
                ],
              ),
            ),
            Text("Max Limit is 2000.00",
                style: Theme.of(context).textTheme.bodyMedium),
            Expanded(
              child: Container(
                width: size.width,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.outline, width: 1.5),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(9.0, 0.0, 9.0, 0.0),
                        child: Row(
                          children: [
                            const CustomCircularAvatar(
                                size: 30,
                                imageSrc: AssetImage("assets/images/pfp.jpeg")),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 10),
                                  child: Text("Send to",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text("Mr. Elon Musk",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .merge(TextStyle(
                                              fontWeight: FontWeight.w700))),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NumPadButton(text: '7'),
                          NumPadButton(text: '8'),
                          NumPadButton(text: '9'),
                          NumPadButton(text: 'X'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NumPadButton(text: '4'),
                          NumPadButton(text: '5'),
                          NumPadButton(text: '6'),
                          NumPadButton(text: '-'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NumPadButton(text: '1'),
                          NumPadButton(text: '2'),
                          NumPadButton(text: '3'),
                          NumPadButton(text: '+'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          NumPadButton(text: '.'),
                          NumPadButton(text: '0'),
                          NumPadButton(text: 'C'),
                          NumPadButton(text: '='),
                        ],
                      ),
                      CustomActionButton(
                        label: "Send",
                        width: size.width,
                        borderRadius: 10,
                      )
                    ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
