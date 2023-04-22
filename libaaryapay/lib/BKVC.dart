import 'dart:typed_data';
import 'package:libaaryapay/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:cryptography/cryptography.dart';

class BalanceKeyVerificationCertificate {
  UuidValue userID;
  double availableBalance;
  Uint8List publicKey;
  DateTime timeStamp;
  List<int> signature;

  BalanceKeyVerificationCertificate(
    this.userID,
    this.availableBalance,
    this.publicKey,
    this.timeStamp,
    this.signature,
  );

  static BalanceKeyVerificationCertificate fromBytes(Uint8List data) {
    final userID = UuidValue.fromByteList(data.sublist(0, 16));
    final availableBalance = ByteData.view(data.buffer).getFloat32(16);
    final publicKey = data.sublist(20, 52);

    final timeStamp = DateTime.fromMillisecondsSinceEpoch(
      ByteData.view(data.buffer).getUint32(52) * 1000,
      isUtc: true,
    );

    final signature = data.sublist(56, 120);

    return BalanceKeyVerificationCertificate(
        userID, availableBalance, publicKey, timeStamp, signature);
  }

  Uint8List toBytes() {
    final buffer = Uint8List(120);

    buffer.setAll(0, userID.toBytes());
    ByteData.view(buffer.buffer).setFloat32(16, availableBalance);
    buffer.setAll(20, publicKey);

    ByteData.view(buffer.buffer)
        .setUint32(52, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    buffer.setAll(56, signature);

    return buffer;
  }

  Future<void> sign(SimpleKeyPair keyPair) async {
    final data = Uint8List(56);

    data.setRange(0, 16, userID.toBytes());
    data.buffer.asByteData().setFloat32(16, availableBalance);
    data.setRange(20, 52, publicKey);

    data.buffer
        .asByteData()
        .setUint32(52, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    var signatureObj = await Ed25519().sign(data, keyPair: keyPair);

    signature = signatureObj.bytes;
  }

  Future<bool> verify(SimplePublicKey serverPublicKey) async {
    final data = Uint8List(56);

    data.setRange(0, 16, userID.toBytes());
    data.buffer.asByteData().setFloat32(16, availableBalance);
    data.setRange(20, 52, publicKey);

    data.buffer
        .asByteData()
        .setUint32(52, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    return Ed25519().verify(data,
        signature: Signature(signature, publicKey: serverPublicKey));
  }
}
