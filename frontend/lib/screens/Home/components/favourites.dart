import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:aaryapay/components/CustomFavoritesAvatar.dart';
import 'package:aaryapay/components/CustomStatusButton.dart';
import 'package:aaryapay/screens/Send/send_money.dart';
import 'package:flutter/material.dart';

class Favourites extends StatelessWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // height: size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Send Money",
                style: textTheme.titleMedium,
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () => {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const SendMoney(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            ),
                          },
                      child: const CustomFavoritesAvatar(
                        imagesUrl: "assets/images/pfp.jpg",
                      )),
                  const CustomFavoritesAvatar(),
                  const CustomFavoritesAvatar(
                    imagesUrl: "assets/images/pfp.jpg",
                  ),
                  const CustomFavoritesAvatar(),
                  const CustomFavoritesAvatar(
                    imagesUrl: "assets/images/pfp.jpg",
                  ),
                  const CustomFavoritesAvatar(),
                  const CustomFavoritesAvatar(
                    imagesUrl: "assets/images/pfp.jpg",
                  ),
                  const CustomFavoritesAvatar(),
                  const CustomFavoritesAvatar(
                    imagesUrl: "assets/images/pfp.jpg",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
