import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:aaryapay/components/CustomFavoritesAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class FavouritesCard extends StatelessWidget {
  const FavouritesCard({
    Key? key,
    this.imageSrc,
    this.name,
    this.userTag,
    this.dateAdded,
    this.onRemove,
  }) : super(key: key);

  final void Function()? onRemove;
  final AssetImage? imageSrc;
  final String? name;
  final String? userTag;
  final String? dateAdded;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      width: size.width,
      decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(40, 0, 0, 0)),
          borderRadius: BorderRadius.circular(10)),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomFavoritesAvatar(
                width: 60,
                imagesUrl: "assets/images/default-pfp.png",
              ),
              Container( 
                width: constraints.maxWidth * 0.55,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(name ?? "", style: textTheme.titleMedium),
                    ),
                    Text(
                      userTag ?? "",
                      style: textTheme.bodyMedium,
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Added on: ",
                    textAlign: TextAlign.right,
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    dateAdded ?? "10th Dec 2020",
                    style: textTheme.bodyMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: onRemove,
                      child: CustomActionButton(
                        width: size.width * 0.18,
                        color: Theme.of(context).colorScheme.primary,
                        height: 35,
                        textTheme: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .merge(
                              TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                        actionLogo: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset(
                            "assets/icons/trash.svg",
                            width: 15,
                            height: 15,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).colorScheme.background,
                                BlendMode.srcIn),
                          ),
                        ),
                        label: "Delete",
                        borderRadius: 5,
                      ),

                      // child: SvgPicture.asset(
                      //   "assets/icons/close.svg",
                      //   width: 12,
                      //   height: 12,
                      //   colorFilter: ColorFilter.mode(
                      //       Theme.of(context).colorScheme.onSurface,
                      //       BlendMode.srcIn),
                      // ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
