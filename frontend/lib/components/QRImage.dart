import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRView extends StatelessWidget {
  final Uint8List? data;
  final int errorCorrectLevel;
  final double size;
  final String stringdata;
  const QRView({
    Key? key,
    required this.stringdata,
    this.size = 250,
    this.data,
    this.errorCorrectLevel = QrErrorCorrectLevel.M,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: stringdata,
      size: size,
    );
    // return QrImageView.withQr(
    //   size: size,
    //   qr: QrCode.fromUint8List(
    //     data: data ?? Uint8List(0),
    //     errorCorrectLevel: errorCorrectLevel,
    //   ),
  }
}
