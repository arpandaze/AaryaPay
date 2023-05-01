import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/global/authentication/authentication_bloc.dart';
import 'package:aaryapay/repository/favourites.dart';
import 'package:aaryapay/screens/Settings/Favourites/bloc/favourites_bloc.dart';
import 'package:aaryapay/screens/Settings/Favourites/favourites_card.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<FavouritesBloc, FavouritesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return SettingsWrapper(
            pageName: " Favourites",
            children: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: CustomTextField(
                        outlined: true,
                        placeHolder: "Enter example@example.com",
                        onChanged: (value) => context
                            .read<FavouritesBloc>()
                            .add(FavouritesFieldChanged(email: value)),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: CustomActionButton(
                          width: size.width * 0.70,
                          borderRadius: 10,
                          label: "Add",
                          onClick: () => context
                              .read<FavouritesBloc>()
                              .add(AddButtonClicked()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "Current Favourites",
                        style: textTheme.titleMedium,
                      ),
                    ),
                    if (state.isLoaded!)
                      ...state.favouritesList!
                          .map((item) => FavouritesCard(
                                imageSrc: AssetImage("assets/images/pfp.jpg"),
                                name: item['first_name'],
                                userTag: item['email'],
                                dateAdded: DateTime.parse(item['date_added'])
                                    .toString()
                                    .substring(0, 10),
                              ))
                          .toList().reversed
                    else
                      Text("${state.isLoaded}"),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
