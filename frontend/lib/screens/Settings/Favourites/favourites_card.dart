import 'package:aaryapay/components/CustomActionButton.dart';
import 'package:aaryapay/constants.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FavouritesCard extends StatelessWidget {
  const FavouritesCard({
    Key? key,
    this.imageSrc,
    required this.name,
    required this.userTag,
    required this.dateAdded,
    this.onRemove,
  }) : super(key: key);

  final void Function()? onRemove;
  final AssetImage? imageSrc;
  final String name;
  final String userTag;
  final String dateAdded;

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
              Container(
                child: imageLoader(imageUrl: "xx", shape: ImageType.initial),
              ),
              Container(
                width: constraints.maxWidth * 0.45,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(name, style: textTheme.titleMedium),
                    ),
                    Text(
                      userTag,
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
                    dateAdded,
                    style: textTheme.bodyMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: onRemove,
                      child: CustomActionButton(
                        width: size.width * 0.08,
                        color: colorScheme.onSurface,
                        height: 35,
                        textTheme: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .merge(
                              TextStyle(
                                  color:
                                      colorScheme.background),
                            ),
                        actionLogo: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset(
                            "assets/icons/trash.svg",
                            width: 15,
                            height: 15,
                            colorFilter: ColorFilter.mode(
                                colorScheme.background,
                                BlendMode.srcIn),
                          ),
                        ),
                        borderRadius: 5,
                      ),
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
