import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRView extends StatelessWidget {
  final Uint8List? data;
  final int errorCorrectLevel;

  const QRView({
    Key? key,
    this.data,
    this.errorCorrectLevel = QrErrorCorrectLevel.M,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImageView.withQr(
      qr: QrCode.fromUint8List(
        data: data ?? Uint8List(0),
        errorCorrectLevel: errorCorrectLevel,
      ),
    );
  }
}
