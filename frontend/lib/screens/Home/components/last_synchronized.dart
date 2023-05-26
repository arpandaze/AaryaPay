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
                          "Unverified Transactions",
                          style: textTheme.titleMedium!.merge(
                              TextStyle(color: colorScheme.onBackground)),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "3",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .merge(
                                      const TextStyle(fontSize: 65, height: 0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Transactions",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            )
                          ],
                        ),
                        Text(
                          "12/04/2023 5:45 pm",
                          style: textTheme.bodyLarge!
                              .merge(TextStyle(color: colorScheme.outline)),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: SvgPicture.asset(
                                "assets/icons/rupee.svg",
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.onBackground,
                                    BlendMode.srcIn),
                                width: 40,
                                height: 40,
                              ),
                            ),
                            Text(
                              "600",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .merge(
                                    const TextStyle(fontSize: 45, height: 0),
                                  ),
                            ),
                          ],
                        ),
                        CustomStatusButton(
                          width: size.width * 0.22,
                          height: size.height * 0.04,
                          label: "Sync",
                          onTap: () => context
                              .read<TopBarBloc>()
                              .add(SyncingEvent(syncing: !state.syncing)),
                          textStyle: textTheme.labelMedium!
                              .merge(const TextStyle(fontSize: 14, height: 0)),
                          widget: CustomSyncRotation(
                              size: 17, syncing: state.syncing),
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
