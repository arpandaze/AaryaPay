import 'package:aaryapay/components/CustomSyncRotation.dart';
import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/screens/Home/components/bloc/last_syncronized_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          create: (context) => LastSyncronizedBloc(),
          child: BlocConsumer<LastSyncronizedBloc, LastSyncronizedState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
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
                      onTap: () => context
                          .read<LastSyncronizedBloc>()
                          .add(SyncingEvent(syncing: !state.syncing)),
                      textStyle: textTheme.labelSmall!
                          .merge(const TextStyle(height: 0)),
                      widget: CustomSyncRotation(syncing: state.syncing),
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
