import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

import 'package:uuid/uuid.dart';
import 'package:libaaryapay/transaction/bkvc.dart';
import 'package:libaaryapay/transaction/constants.dart';

class TransactionVerificationCertificate {
  int messageType;
  double amount;
  UuidValue from;
  BalanceKeyVerificationCertificate bkvc;
  DateTime timeStamp;
  List<int> signature = List<int>.filled(64, 0, growable: false);

  TransactionVerificationCertificate(
    this.messageType,
    this.amount,
    this.from,
    this.bkvc,
    this.timeStamp, {
    List<int>? signature,
  }) {
    if (signature != null) {
      this.signature = signature;
    }
  }

  Uint8List toBytes() {
    final buffer = Uint8List(210);

    buffer[0] = TVC_MESSAGE_TYPE;
    buffer.buffer.asByteData().setFloat32(1, amount);
    buffer.setRange(5, 21, from.toBytes());
    buffer.setRange(21, 142, bkvc.toBytes());

    buffer.buffer
        .asByteData()
        .setUint32(142, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    buffer.setRange(146, 210, signature);

    return buffer;
  }

  static TransactionVerificationCertificate fromBytes(Uint8List data) {
    final messageType = data[0];
    final amount = ByteData.view(data.buffer).getFloat32(1);
    final to = UuidValue.fromByteList(data.sublist(5, 21));
    final bkvc =
        BalanceKeyVerificationCertificate.fromBytes(data.sublist(21, 142));

    final timeStamp = DateTime.fromMillisecondsSinceEpoch(
      ByteData.view(data.buffer).getUint32(142) * 1000,
      isUtc: true,
    );

    final signature = data.sublist(146, 210);

    return TransactionVerificationCertificate(
      messageType,
      amount,
      to,
      bkvc,
      timeStamp,
      signature: signature,
    );
  }

  Future<void> sign(SimpleKeyPair serverKeyPair) async {
    final data = Uint8List(146);
    data[0] = TVC_MESSAGE_TYPE;
    data.buffer.asByteData().setFloat32(1, amount);
    data.setRange(5, 21, from.toBytes());
    data.setRange(21, 142, bkvc.toBytes());

    data.buffer
        .asByteData()
        .setUint32(142, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    final signatureObj = await Ed25519().sign(data, keyPair: serverKeyPair);
    signature = signatureObj.bytes;
  }

  Future<bool> verify(SimplePublicKey serverPublicKey) async {
    final data = Uint8List(146);
    data[0] = TVC_MESSAGE_TYPE;
    data.buffer.asByteData().setFloat32(1, amount);
    data.setRange(5, 21, from.toBytes());
    data.setRange(21, 142, bkvc.toBytes());

    data.buffer
        .asByteData()
        .setUint32(142, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    return await Ed25519().verify(
      data,
      signature: Signature(signature, publicKey: serverPublicKey),
    );
  }

  static TransactionVerificationCertificate fromBase64(String base64) {
    return fromBytes(base64Decode(base64));
  }

  DateTime get generationTime => timeStamp;
  DateTime get verificationTime => bkvc.timeStamp;
}
