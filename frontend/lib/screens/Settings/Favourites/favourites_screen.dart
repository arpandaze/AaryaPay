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
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    List<FavouritesModal> itemList = [
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10 Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
      FavouritesModal(const AssetImage("assets/images/default-pfp.png"),
          "Mukesh",
          "@iownindia", "10th Dec,2020"),
    ];
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return SettingsWrapper(
        pageName: " Favourites",
        children: SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CustomTextField(
                    outlined: true,
                    suffixIcon: Container(
                      padding: const EdgeInsets.all(15),
                      child: SvgPicture.asset(
                        "assets/icons/bill-fill.svg",
                        width: 1,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: CustomActionButton(
                    width: size.width * 0.5,
                    height: 50,
                    borderRadius: 10,
                    label: "Save",
                    onClick: () => itemList.add(FavouritesModal(
                        const AssetImage("assets/images/default-pfp.png"),
                        "Aatish",
                        "@iamaatish",
                        "10th Dec, 2020")),
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
        ));
  }
}
