import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Send/bloc/send_money_bloc.dart';
import 'package:aaryapay/screens/Send/components/balance_box.dart';
import 'package:aaryapay/screens/Send/components/numpad_button.dart';
import 'package:aaryapay/screens/Send/payment_complete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

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
      ),
    );
  }

  Widget body(Size size, BuildContext context) {
    return BlocBuilder<SendMoneyBloc, SendMoneyState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.1,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.background),
                        ),
                        child: Transform.rotate(
                          angle: -math.pi,
                          child: SvgPicture.asset(
                            "assets/icons/arrow2.svg",
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Text("Send Money",
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ),
                ],
              ),
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
                      margin: const EdgeInsets.only(left: 15),
                      child: Text("${state.displayAmount}",
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
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(10),
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
                                imageSrc: AssetImage("assets/images/pfp.jpg")),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  child: Text("Send to",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text("Mr. Elon Musk",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .merge(const TextStyle(
                                              fontWeight: FontWeight.w700))),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          NumPadButton(text: '7'),
                          NumPadButton(text: '8'),
                          NumPadButton(text: '9'),
                          NumPadButton(text: 'X'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          NumPadButton(text: '4'),
                          NumPadButton(text: '5'),
                          NumPadButton(text: '6'),
                          NumPadButton(text: '-'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          NumPadButton(text: '1'),
                          NumPadButton(text: '2'),
                          NumPadButton(text: '3'),
                          NumPadButton(text: '+'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const NumPadButton(text: '.'),
                          const NumPadButton(text: '0'),
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
                          const NumPadButton(text: '='),
                        ],
                      ),
                      CustomActionButton(
                        label: "Send",
                        width: size.width,
                        borderRadius: 10,
                      onClick: () => Utils.mainAppNav.currentState!.push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const PaymentComplete(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final curve = CurvedAnimation(
                                parent: animation,
                                curve: Curves.decelerate,
                              );

                              return Stack(
                                children: [
                                  FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 1.0,
                                      end: 0.0,
                                    ).animate(curve),
                                  ),
                                  SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0.0, 1.0),
                                      end: Offset.zero,
                                    ).animate(curve),
                                    child: FadeTransition(
                                      opacity: Tween<double>(
                                        begin: 0.0,
                                        end: 1.0,
                                      ).animate(curve),
                                      child: const PaymentComplete(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
