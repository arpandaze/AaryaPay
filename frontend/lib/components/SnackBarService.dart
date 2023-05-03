import 'dart:async';

import 'package:aaryapay/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackBarService {
  static final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(
      {required String? content, MessageType msgType = MessageType.error}) {
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        closeIconColor: Colors.white,
        showCloseIcon: true,
        content: Text(content ?? "",
            style: GoogleFonts.mulish(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                color: const Color(0xFFFFFFFF),
                height: 1.5)),
        backgroundColor: msgType == MessageType.success
            ? const Color.fromARGB(255, 29, 153, 84)
            : msgType == MessageType.neutral
                ? const Color.fromARGB(255, 160, 160, 160)
                : msgType == MessageType.warning
                    ? const Color(0xffFFAB2D)
                    : const Color.fromARGB(255, 206, 52, 52),
      ),
    );
    // var timer = Timer(const Duration(seconds: 4), () =>stopSnackBar());
  }

  static void stopSnackBar(){
    scaffoldKey.currentState?.clearSnackBars();
  }
}
