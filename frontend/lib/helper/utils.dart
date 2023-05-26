import 'dart:async';

import 'package:aaryapay/components/CircularLoadingAnimation.dart';
import 'package:aaryapay/components/CustomCircularAvatar.dart';
import 'package:aaryapay/components/CustomFavoritesAvatar.dart';
import 'package:aaryapay/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:jovial_svg/jovial_svg.dart';

class Utils {
  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();
  static GlobalKey<NavigatorState> mainListNav = GlobalKey();
  final DefaultCacheManager cacheManager = DefaultCacheManager();

  static Widget mainlogo = ScalableImageWidget.fromSISource(
    si: ScalableImageSource.fromSvg(
      MySVG(imagePath: "assets/icons/logo.svg"),
      "mainLogo",
      compact: true,
    ),
  );

  static Widget background = ScalableImageWidget.fromSISource(
    si: ScalableImageSource.fromSvg(
      MySVG(imagePath: "assets/svgs/bamboo.svg"),
      "background",
      compact: true,
    ),
  );
}

class MySVG extends AssetBundle {
  final String imagePath;
  MySVG({required this.imagePath});
  @override
  Future<ByteData> load(String key) async {
    return await rootBundle.load(imagePath);
  }

  @override
  Future<T> loadStructuredData<T>(
      String key, Future<T> Function(String value) parser) {
    throw UnimplementedError();
  }
}

Widget imageLoader({
  required String imageUrl,
  double width = 60,
  double height = 60,
  ImageType shape = ImageType.circle,
  double radius = 0,
  Widget errorImage = const CustomFavoritesAvatar(
    imagesUrl: "assets/images/default-pfp.png",
  ),
}) {
  final String url = '$fileServerBase/$imageUrl';

  Future<FileInfo> fetchImage() async {
    final searchInCache = await Utils().cacheManager.getFileFromCache(url);
    if (searchInCache != null) {
      return searchInCache;
    } else {
      await Utils().cacheManager.downloadFile(url);
      final cachedImage = await Utils().cacheManager.getFileFromCache(url);
      return cachedImage!;
    }
  }

  return FutureBuilder(
    future: fetchImage(),
    builder: (_, snapshot) {
      if (snapshot.hasData) {
        switch (shape) {
          case ImageType.circle:
            return Container(
              width: width,
              height: height,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(snapshot.data!.file),
                ),
              ),
            );
          case ImageType.rectangle:
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(snapshot.data!.file),
                ),
              ),
            );
          default:
            return CustomCircularAvatar(image: FileImage(snapshot.data!.file));
        }
      } else if (snapshot.hasError) {
        return errorImage; 
      } else {
        return CircularLoadingAnimation(
          width: width,
          height: height,
          shape: shape,
        );
      }
    },
  );
}

Future<bool> checkInternetConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}
