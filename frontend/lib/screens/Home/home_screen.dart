import 'package:aaryapay/global/bloc/data_bloc.dart';
import 'package:aaryapay/screens/Home/components/recent_card.dart';
import 'package:flutter/material.dart';
import 'package:aaryapay/screens/Home/components/favourites.dart';
import 'package:aaryapay/screens/Home/components/last_synchronized.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        context.read<DataBloc>().add(RequestSyncEvent());
      },
      child: BlocConsumer<DataBloc, DataState>(
        listener: (context, state) {},
        listenWhen: (previous, current) => previous != current,
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return GestureDetector(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Color(0xfff4f6f4),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Favourites(),
                    LastSynchronized(),
                    RecentCard(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
