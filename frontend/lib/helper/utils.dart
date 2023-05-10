import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jovial_svg/jovial_svg.dart';

class Utils {

  static GlobalKey<NavigatorState> mainAppNav = GlobalKey();
  static GlobalKey<NavigatorState> mainListNav = GlobalKey();

  static Widget mainlogo = ScalableImageWidget.fromSISource(
    si: ScalableImageSource.fromSvg(
      MySVG(imagePath: "assets/icons/logo.svg"),
      "mainLogo",
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
