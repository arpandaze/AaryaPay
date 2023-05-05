import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:libaaryapay/libaaryapay.dart';
import 'package:uuid/uuid.dart';
import 'package:libaaryapay/constants.dart';

class TransactionVerificationCertificate {
  int messageType;
  List<int> transactionSignature;
  UuidValue transactionID;
  BalanceKeyVerificationCertificate bkvc;
  List<int> signature = List<int>.filled(64, 0, growable: false);

  TransactionVerificationCertificate(
    this.messageType,
    this.transactionSignature,
    this.transactionID,
    this.bkvc, {
    List<int>? signature,
  }) {
    if (signature != null) {
      this.signature = signature;
    }
  }

  Future<void> sign(SimpleKeyPair keyPair) async {
    final data = Uint8List(202);

    data[0] = TVC_MESSAGE_TYPE;
    data.setAll(1, transactionSignature);
    data.setAll(65, transactionID.toBytes());
    data.setAll(81, bkvc.toBytes());

    var signatureObj = await Ed25519().sign(data, keyPair: keyPair);

    signature = signatureObj.bytes;
  }

  Uint8List toBytes() {
    final buffer = Uint8List(185);

    buffer[0] = TVC_MESSAGE_TYPE;
    buffer.setAll(1, transactionSignature);
    buffer.setAll(65, transactionID.toBytes());
    buffer.setAll(81, bkvc.toBytes());

    buffer.setAll(202, signature);

    return buffer;
  }

  Future<bool> verify(SimplePublicKey serverPublicKey) async {
    final data = Uint8List(202);

    data[0] = TVC_MESSAGE_TYPE;
    data.setRange(1, 65, transactionSignature);
    data.setRange(65, 81, transactionID.toBytes());
    data.setRange(81, 202, bkvc.toBytes());

    return Ed25519().verify(
      data,
      signature: Signature(signature, publicKey: serverPublicKey),
    );
  }

  static TransactionVerificationCertificate fromBytes(
    Uint8List bytes,
  ) {
    final messageType = TVC_MESSAGE_TYPE;
    final transactionSignature = bytes.sublist(1, 65);
    final transactionID = UuidValue.fromByteList(bytes.sublist(65, 81));
    final bkvc = BalanceKeyVerificationCertificate.fromBytes(
      bytes.sublist(81, 202),
    );
    final signature = bytes.sublist(202);

    return TransactionVerificationCertificate(
      messageType,
      transactionSignature,
      transactionID,
      bkvc,
      signature: signature,
    );
  }
}
