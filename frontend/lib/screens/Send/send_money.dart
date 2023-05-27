import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Send/bloc/send_money_bloc.dart';
import 'package:aaryapay/screens/Send/components/balance_box.dart';
import 'package:aaryapay/screens/Send/offline_send.dart';
import 'package:aaryapay/screens/Send/components/midMatrix.dart';
import 'package:aaryapay/screens/Send/payment_complete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

class SendMoney extends StatelessWidget {
  final String? firstname;
  final String? lastname;
  final String? uuid;
  final String displayAmount;

  const SendMoney(
      {Key? key,
      required this.firstname,
      required this.uuid,
      required this.lastname,
      required this.displayAmount})
      : super(key: key);
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
    return BlocConsumer<DataBloc, DataState>(
      listenWhen: (previous, current) =>
          previous.goToScreen != current.goToScreen,
      listener: (context, dataState) {
        if (dataState.goToScreen == GoToScreen.offlineTrans) {
          Utils.mainAppNav.currentState!.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  OfflineSend(
                name:
                    "${dataState.profile!.firstName} ${dataState.profile!.lastName}",
                transaction: dataState.latestTransaction,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
                        child: OfflineSend(
                            name:
                                "${dataState.profile!.firstName} ${dataState.profile!.lastName}",
                            transaction: dataState.latestTransaction),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        if (dataState.goToScreen == GoToScreen.onlineTrans) {
          Utils.mainAppNav.currentState!.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PaymentComplete(
                transaction: dataState.latestTransaction!,
                sender: true,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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
                        child: PaymentComplete(
                          transaction: dataState.latestTransaction!,
                          sender: true,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
      builder: (context, dataState) {
        double sentAmount = dataState.transactions.getSentAmount();
        double balance = dataState.bkvc!.availableBalance;
        double availableAmount = balance - sentAmount;
        return BlocConsumer<SendMoneyBloc, SendMoneyState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) => {
            if (state.tamStatus == TAMStatus.initiated)
              {dialogBuilder(context, 'assets/animations/paperplane.json')},
            if (state.tamStatus == TAMStatus.generated)
              {
                context.read<DataBloc>().add(SubmitTAMEvent(state.tam!)),
              },
            if (state.error)
              {
                SnackBarService.stopSnackBar(),
                SnackBarService.showSnackBar(
                  msgType: MessageType.error,
                  content: state.errorText,
                ),
              }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.1,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () =>
                                  Utils.mainAppNav.currentState!.popUntil(
                                ModalRoute.withName("/app"),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background),
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
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BalanceBox(
                      balance: displayAmount.toString(),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(maxHeight: size.height * 0.07),
                      height: size.height * 0.07,
                      margin: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              width: 2.0,
                              color: Theme.of(context).colorScheme.outline),
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
                              constraints:
                                  BoxConstraints(maxWidth: size.width * 0.55),
                              margin: const EdgeInsets.only(left: 15),
                              child: Text(state.displayAmount,
                                  textDirection: TextDirection.ltr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)))),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: size.width,
                    constraints: BoxConstraints(maxHeight: size.height * 0.6),
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 20.0, left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1.5),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                        color: const Color(0xfff4f6fa)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(9.0, 10.0, 9.0, 0.0),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: imageLoader(
                                    imageUrl: uuid!,
                                    shape: ImageType.circle,
                                    errorImage: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/default-pfp.png")),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    child: Text("$firstname $lastname",
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
                        Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: const Center(
                            child: midMatrix(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: CustomActionButton(
                            label: "Send",
                            width: size.width * 0.7,
                            borderRadius: 10,
                            onClick: () => {
                              context.read<SendMoneyBloc>().add(
                                    SubmitTransfer(
                                      UuidValue.fromList(Uuid.parse(uuid!)),
                                      "${context.read<AuthenticationBloc>().state.user!["first_name"]} ${context.read<AuthenticationBloc>().state.user!["last_name"]}",
                                      "$firstname $lastname",
                                      availableAmount,
                                    ),
                                  ),
                            },
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
      },
    );
  }
}
