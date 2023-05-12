import 'package:aaryapay/components/CustomFavoritesAvatar.dart';
import 'package:aaryapay/helper/utils.dart';
import 'package:aaryapay/screens/Send/send_money.dart';
import 'package:flutter/material.dart';

class Favourites extends StatelessWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
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
                      Utils.mainAppNav.currentState!.push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SendMoney(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final curve = CurvedAnimation(
                              parent: animation,
                              curve: Curves.decelerate,
                            );

                            return Stack(
                              children: [
                                FadeTransition(
                                  opacity: Tween<double>(
                                    begin: 1.0,
                                    end: 0.0,
                                  ).animate(curve),
                                ),
                                SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 1.0),
                                    end: Offset.zero,
                                  ).animate(curve),
                                  child: FadeTransition(
                                    opacity: Tween<double>(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(curve),
                                    child: const SendMoney(),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                          },
                      child: const CustomFavoritesAvatar(
                        imagesUrl: "assets/images/pfp.jpg",
                    ),
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
