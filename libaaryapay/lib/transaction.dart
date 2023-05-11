import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

import 'package:uuid/uuid.dart';
import 'package:libaaryapay/bkvc.dart';
import 'package:libaaryapay/constants.dart';

class Transaction {
  int messageType;
  double amount;
  UuidValue to;
  BalanceKeyVerificationCertificate bkvc;
  DateTime timeStamp;
  List<int> signature = List<int>.filled(64, 0, growable: false);

  Transaction(
    this.messageType,
    this.amount,
    this.to,
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

    buffer[0] = TAM_MESSAGE_TYPE;
    buffer.buffer.asByteData().setFloat32(1, amount);
    buffer.setRange(5, 21, to.toBytes());
    buffer.setRange(21, 142, bkvc.toBytes());

    buffer.buffer
        .asByteData()
        .setUint32(142, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    buffer.setRange(146, 210, signature);

    return buffer;
  }

  static Transaction fromBytes(Uint8List data) {
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

    return Transaction(
      messageType,
      amount,
      to,
      bkvc,
      timeStamp,
      signature: signature,
    );
  }

  Future<void> sign(SimpleKeyPair keyPair) async {
    final data = Uint8List(146);
    data[0] = TAM_MESSAGE_TYPE;
    data.buffer.asByteData().setFloat32(1, amount);
    data.setRange(5, 21, to.toBytes());
    data.setRange(21, 142, bkvc.toBytes());

    data.buffer
        .asByteData()
        .setUint32(142, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    final signatureObj = await Ed25519().sign(data, keyPair: keyPair);
    signature = signatureObj.bytes;
  }

  Future<bool> verify() async {
    final data = Uint8List(146);
    data[0] = TAM_MESSAGE_TYPE;
    data.buffer.asByteData().setFloat32(1, amount);
    data.setRange(5, 21, to.toBytes());
    data.setRange(21, 142, bkvc.toBytes());

    data.buffer
        .asByteData()
        .setUint32(142, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    return await Ed25519().verify(
      data,
      signature: Signature(signature, publicKey: await bkvc.getPublicKey()),
    );
  }
}
