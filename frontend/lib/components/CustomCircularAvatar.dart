import 'package:aaryapay/components/CustomTextField.dart';
import 'package:aaryapay/screens/Home/home_screen.dart';
import 'package:aaryapay/screens/Login/components/login_wrapper.dart';
import 'package:aaryapay/screens/Login/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCircularAvatar extends StatelessWidget {
  const CustomCircularAvatar({Key? key, required this.imageSrc, this.size})
      : super(key: key);
  final AssetImage imageSrc;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(5),
      child: CircleAvatar(
        radius: size ?? 25,
        backgroundImage: imageSrc,
        // color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
