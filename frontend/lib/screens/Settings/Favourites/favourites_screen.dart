import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Settings/Favourites/favourites_card.dart';
import 'package:aaryapay/screens/Settings/components/settings_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FavouritesModal {
  final AssetImage? imageSrc;
  final String? name;
  final String? userTag;
  final String? dateAdded;

  FavouritesModal(this.imageSrc, this.name, this.userTag, this.dateAdded);
}

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.background,
      child: body(context),
    );
  }

  Widget body(BuildContext context) {
    List<FavouritesModal> itemList = [
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10 Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh", "@iownindia", "10th Dec,2020"),
    ];
    var textTheme = Theme.of(context).textTheme;
    Size size = MediaQuery.of(context).size;
    return SettingsWrapper(
        pageName: " Favourites",
        children: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: size.width * 0.9,
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomTextField(
                      outlined: true,
                      placeHolder: "Enter example@example.com",
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CustomActionButton(
                        width: size.width * 0.70,
                        borderRadius: 10,
                        label: "Add",
                        onClick: () => itemList.add(FavouritesModal(
                            const AssetImage("assets/images/default-pfp.png"),
                            "Aatish",
                            "@iamaatish",
                            "10th Dec, 2020")),
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
                  ...itemList
                      .map((item) => FavouritesCard(
                            imageSrc: item.imageSrc,
                            name: item.name,
                            userTag: item.userTag,
                            dateAdded: item.dateAdded,
                          ))
                      .toList()
                ],
              ),
            ),
          ),
        ));
  }
}
