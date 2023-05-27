import 'package:aaryapay/components/CustomSyncRotation.dart';
import 'package:aaryapay/components/bloc/top_bar_bloc.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:aaryapay/components/CustomStatusButton.dart';

class LastSynchronized extends StatelessWidget {
  const LastSynchronized({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<DataBloc, DataState>(
      buildWhen: (prev, next) => prev.isOnline != next.isOnline,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => TopBarBloc(),
          child: BlocConsumer<TopBarBloc, TopBarState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  gradient: const SweepGradient(
                    colors: [Color(0xff274233), Color(0xff39a669)],
                    stops: [0, 1],
                    center: Alignment.topRight,
                  ),
                  border: Border.all(color: const Color(0x20000000)),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                width: size.width * 0.9,
                height: size.height * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Balance",
                          style: Theme.of(context).textTheme.labelMedium!.merge(
                                TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
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
                            GestureDetector(
                              onTap: () => {
                                context
                                    .read<TopBarBloc>()
                                    .add(EyeTapped(tapped: !state.hide)),
                              },
                              child: SizedBox(
                                width: size.width * 0.45,
                                child: Text(
                                  "XXX.XXX",
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "3",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .merge(const TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: 65,
                                      height: 0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Unverified Transactions",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .merge(
                                        const TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last Synchronized Time",
                              style: textTheme.bodySmall!.merge(
                                  TextStyle(color: colorScheme.background)),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "12/04/2023 5:45 pm",
                                style: textTheme.bodyLarge!.merge(
                                    TextStyle(color: colorScheme.background)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomStatusButton(
                          width: size.width * 0.22,
                          height: size.height * 0.04,
                          label: "Sync",
                          color: Colors.white,
                          onTap: () => context
                              .read<TopBarBloc>()
                              .add(SyncingEvent(syncing: !state.syncing)),
                          textStyle: textTheme.labelMedium!.merge(
                              const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 0)),
                          widget: CustomSyncRotation(
                              color: Colors.white,
                              size: 17,
                              syncing: state.syncing),
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
