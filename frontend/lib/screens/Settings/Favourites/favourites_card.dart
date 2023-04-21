import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:flutter/material.dart';

class FavouritesCard extends StatelessWidget {
  const FavouritesCard({
    Key? key,
    this.imageSrc,
    this.name,
    this.userTag,
    this.dateAdded,
  }) : super(key: key);

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
      padding: const EdgeInsets.all(5),
      width: size.width,
      height: size.height * 0.1,
      decoration: BoxDecoration(
          border: Border.all(color: colorScheme.onPrimary),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomCircularAvatar(
                  imageSrc:
                      imageSrc ??
                      const AssetImage("assets/images/default-pfp.png")),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? "Mukesh",
                    style: textTheme.titleSmall!
                        .merge(const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Text(
                    userTag ?? "@iownindia",
                    style: textTheme.bodySmall,
                  )
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  width: size.width * 0.18,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Pending",
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall!.merge(
                      TextStyle(color: colorScheme.background),
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Added on: ",
                    style: textTheme.labelSmall,
                  ),
                  Text(
                    dateAdded ?? "10th Dec 2020",
                    style: textTheme.labelSmall!
                        .merge(const TextStyle(fontWeight: FontWeight.w700)),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
