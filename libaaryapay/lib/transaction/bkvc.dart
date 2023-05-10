import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';
import 'package:libaaryapay/transaction/constants.dart';

class BalanceKeyVerificationCertificate {
  int messageType;
  UuidValue userID;
  double availableBalance;
  Uint8List publicKey;
  DateTime timeStamp;
  List<int> signature = List<int>.filled(64, 0, growable: false);

  BalanceKeyVerificationCertificate(
    this.messageType,
    this.userID,
    this.availableBalance,
    this.publicKey,
    this.timeStamp, {
    List<int>? signature,
  }) {
    if (signature != null) {
      this.signature = signature;
    }
  }

  Future<SimplePublicKey> getPublicKey() async {
    return SimplePublicKey(publicKey, type: KeyPairType.ed25519);
  }

  Future<void> sign(SimpleKeyPair keyPair) async {
    final data = Uint8List(57);

    data[0] = BKVC_MESSAGE_TYPE;
    data.setRange(1, 17, userID.toBytes());
    data.buffer.asByteData().setFloat32(17, availableBalance);
    data.setRange(21, 53, publicKey);

    data.buffer
        .asByteData()
        .setUint32(53, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    var signatureObj = await Ed25519().sign(data, keyPair: keyPair);
    signature = signatureObj.bytes;
  }

  Uint8List toBytes() {
    final buffer = Uint8List(121);

    buffer[0] = messageType;
    buffer.setAll(1, userID.toBytes());
    ByteData.view(buffer.buffer).setFloat32(17, availableBalance);
    buffer.setAll(21, publicKey);

    ByteData.view(buffer.buffer)
        .setUint32(53, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    buffer.setAll(57, signature);

    return buffer;
  }

  Future<bool> verify(SimplePublicKey serverPublicKey) async {
    final data = Uint8List(57);

    data[0] = BKVC_MESSAGE_TYPE;
    data.setRange(1, 17, userID.toBytes());
    data.buffer.asByteData().setFloat32(17, availableBalance);
    data.setRange(21, 53, publicKey);

    data.buffer
        .asByteData()
        .setUint32(53, timeStamp.toUtc().millisecondsSinceEpoch ~/ 1000);

    return Ed25519().verify(data,
        signature: Signature(signature, publicKey: serverPublicKey));
  }

  static BalanceKeyVerificationCertificate fromBytes(Uint8List data) {
    final messageType = BKVC_MESSAGE_TYPE;
    final userID = UuidValue.fromByteList(data.sublist(1, 17));
    final availableBalance = ByteData.view(data.buffer).getFloat32(17);
    final publicKey = data.sublist(21, 53);

    final timeStamp = DateTime.fromMillisecondsSinceEpoch(
      ByteData.view(data.buffer).getUint32(53) * 1000,
      isUtc: true,
    );

    final signature = data.sublist(57, 121);

    return BalanceKeyVerificationCertificate(
      messageType,
      userID,
      availableBalance,
      publicKey,
      timeStamp,
      signature: signature,
    );
  }
}
