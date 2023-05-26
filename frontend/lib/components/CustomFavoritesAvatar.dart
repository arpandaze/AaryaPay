import 'package:flutter/material.dart';

class CustomFavoritesAvatar extends StatelessWidget {
  const CustomFavoritesAvatar({
    Key? key,
    this.width = 82,
    this.imagesUrl = "assets/images/default-pfp.png",
  }) : super(key: key);

  final String imagesUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), shape: BoxShape.circle),
      child: Container(
        width: width - 10,
        height: width - 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage(imagesUrl),
          ),
        ),
      ),
    );
  }
}
