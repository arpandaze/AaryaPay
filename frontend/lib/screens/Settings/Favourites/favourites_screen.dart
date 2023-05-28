import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/components/SnackBarService.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/repository/favourites.dart';
import 'package:aaryapay/screens/Settings/Favourites/bloc/favourites_bloc.dart';
import 'package:aaryapay/screens/Settings/Favourites/favourites_card.dart';
import 'package:aaryapay/screens/Settings/Favourites/grey_card.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FavouritesModal {
  final AssetImage? imageSrc;
  final String? name;
  final String? userTag;
  final String? dateAdded;

  FavouritesModal(
      {this.imageSrc = const AssetImage("assets/images/default-pfp.png"),
      this.name,
      this.userTag,
      this.dateAdded});
}

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return BlocProvider<FavouritesBloc>(
      create: (context) => FavouritesBloc(
        favouritesRepository: FavouritesRepository(
            token: context.read<AuthenticationBloc>().state.token),
      ),
      child: Container(
        color: colorScheme.background,
        child: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<FavouritesBloc, FavouritesState>(
      listener: (context, state) {
        if (state.msgType == MessageType.error ||
            state.msgType == MessageType.warning ||
            state.msgType == MessageType.success) {
          SnackBarService.stopSnackBar();
          SnackBarService.showSnackBar(
            content: state.errorText,
            msgType: state.msgType,
          );
        }
      },
      builder: (context, state) {
        return SettingsWrapper(
            pageName: " Favourites",
            children: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Add to Favourites",
                        style: textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: CustomTextField(
                        outlined: true,
                        placeHolder: "Enter example@example.com",
                        onChanged: (value) => context
                            .read<FavouritesBloc>()
                            .add(FavouritesFieldChanged(email: value)),
                      ),
                    ),
                    Center(
                      child: CustomActionButton(
                        width: size.width * 0.70,
                        borderRadius: 10,
                        label: "Add",
                        color: Theme.of(context).colorScheme.tertiary,
                        onClick: () => context
                            .read<FavouritesBloc>()
                            .add(AddButtonClicked()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                      child: Text(
                        "Current Favourites",
                        style: textTheme.titleMedium,
                      ),
                    ),
                    if (state.isLoaded && state.favouritesList!.isNotEmpty)
                      ...state.favouritesList!
                          .map(
                            (item) => FavouritesCard(
                              imageSrc:
                                  const AssetImage("assets/images/pfp.jpg"),
                              name: item['first_name'],
                              userTag: item['email'],
                              dateAdded: DateFormat.yMMMMd().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                        item['date_added'] * 1000,
                                        isUtc: true)
                                    .toLocal(),
                              ),
                              onRemove: () => context
                                  .read<FavouritesBloc>()
                                  .add(RemoveEvent(email: item['email'])),
                            ),
                          )
                          .toList()
                          .reversed
                    else
                      FutureBuilder<bool>(
                        future:
                            Future.delayed(const Duration(seconds: 5), () => false),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const GreyCard();
                          } else {
                            // Show the second container after the delay
                            return const Text("No Favourites to show");
                          }
                        },
                      ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
