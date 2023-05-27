import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/components/bloc/top_bar_bloc.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Settings/AccountInformation/account_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataBloc, DataState>(
      listenWhen: (previous, current) => previous.isOnline != current.isOnline,
      listener: (context, dataState) => {
        if (dataState.isOnline)
          {
            SnackBarService.stopSnackBar(),
            SnackBarService.showSnackBar(
              msgType: MessageType.success,
              content: "You are back Online!",
            ),
          }
        else
          {
            SnackBarService.stopSnackBar(),
            SnackBarService.showSnackBar(
              msgType: MessageType.error,
              content: "You are currently Offline!",
            ),
          }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, dataState) {
        var onlineState = dataState.isOnline;
        return BlocProvider(
          create: (context) => TopBarBloc(),
          child: BlocConsumer<TopBarBloc, TopBarState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Balance",
                            style:
                                Theme.of(context).textTheme.labelMedium!.merge(
                                      TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                    ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SvgPicture.asset(
                                "assets/icons/rupee.svg",
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.background,
                                    BlendMode.srcIn),
                                width: 20,
                                height: 20,
                              ),
                            ),
                            SizedBox(
                              // width: size.width * 0.45,
                              child: Text(
                                !state.hide
                                    ? dataState.bkvc?.availableBalance
                                            .toString() ??
                                        "1200"
                                    : "XXX.XXX",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .merge(TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => {
                                context
                                    .read<TopBarBloc>()
                                    .add(EyeTapped(tapped: !state.hide)),
                              },
                              child: SizedBox(
                                // width: size.width * 0.45,
                                child: Text(
                                  !state.hide ? state.amount : "XXX.XXX",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Utils.mainAppNav.currentState!.push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const AccountInformation(),
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
                                          child: const AccountInformation(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            child: Stack(clipBehavior: Clip.none, children: [
                              imageLoader(
                                imageUrl: state.uuid ?? "",
                                shape: ImageType.rectangle,
                                radius: 20,
                                width: 100,
                                height: 100,
                                errorImage: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          ("assets/images/default-pfp.png")),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -10,
                                right: -5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: const SweepGradient(
                                        colors: [
                                          Color(0xff274233),
                                          Color(0xff39a669)
                                        ],
                                        stops: [0, 1],
                                        center: Alignment.topRight,
                                      ),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      // .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20)),
                                  width: 30,
                                  height: 30,
                                  padding: const EdgeInsets.all(6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: onlineState
                                            ? Theme.of(context)
                                                .colorScheme
                                                .surfaceVariant
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                        // .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
