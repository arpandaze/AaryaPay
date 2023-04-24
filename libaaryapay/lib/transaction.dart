import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

import 'package:uuid/uuid.dart';
import 'package:libaaryapay/BKVC.dart';

class Transaction {
  double amount;
  UuidValue to;
  BalanceKeyVerificationCertificate bkvc;
  List<int> signature;
  DateTime timeStamp;

  Transaction(this.amount, this.to, this.bkvc, this.signature, this.timeStamp);

  Uint8List toBytes() {
    final buffer = Uint8List(208);

    buffer.buffer.asByteData().setFloat32(0, amount);
    buffer.setRange(4, 20, to.toBytes());
    buffer.setRange(20, 140, bkvc.toBytes());

    buffer.buffer
        .asByteData()
        .setUint32(140, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    buffer.setRange(144, 208, signature);

    return buffer;
  }

  static Transaction fromBytes(Uint8List data) {
    final amount = ByteData.view(data.buffer).getFloat32(0);
    final to = UuidValue.fromByteList(data.sublist(4, 20));
    final bkvc =
        BalanceKeyVerificationCertificate.fromBytes(data.sublist(20, 140));

    final timeStamp = DateTime.fromMillisecondsSinceEpoch(
      ByteData.view(data.buffer).getUint32(140) * 1000,
      isUtc: true,
    );

    final signature = data.sublist(144, 208);

    return Transaction(amount, to, bkvc, signature, timeStamp);
  }

  Future<void> sign(SimpleKeyPair keyPair) async {
    final data = Uint8List(144);
    data.buffer.asByteData().setFloat32(0, amount);
    data.setRange(4, 20, to.toBytes());
    data.setRange(20, 140, bkvc.toBytes());

    data.buffer
        .asByteData()
        .setUint32(140, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    final signatureObj = await Ed25519().sign(data, keyPair: keyPair);
    signature = signatureObj.bytes;
  }

  Future<bool> verify(SimplePublicKey publicKey) async {
    final data = Uint8List(144);
    data.buffer.asByteData().setFloat32(0, amount);
    data.setRange(4, 20, to.toBytes());
    data.setRange(20, 140, bkvc.toBytes());

    data.buffer
        .asByteData()
        .setUint32(140, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    return await Ed25519().verify(
      data,
      signature: Signature(signature, publicKey: publicKey),
    );
  }
}
