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
      padding: const EdgeInsets.all(10),
      width: size.width,
      decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(40, 0, 0, 0)),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    shape: BoxShape.circle),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage("assets/images/pfp.jpg"),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child:
                          Text(name ?? "Mukesh", style: textTheme.titleMedium),
                    ),
                    Text(
                      userTag ?? "@iownindia",
                      style: textTheme.bodyMedium,
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  width: size.width * 0.22,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15)),
                  child: Text(
                    "Pending",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium!.merge(
                      TextStyle(color: colorScheme.background),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Added on: ",
                      style: textTheme.bodyMedium,
                    ),
                    Text(
                      dateAdded ?? "10th Dec 2020",
                      style: textTheme.bodyMedium,
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
