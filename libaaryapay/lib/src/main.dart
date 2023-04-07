import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert';

import 'package:libaaryapay/src/main.dart';

import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class LibAaryaPay {
  static final algorithm = Ed25519();
  List<int> bVCertificate;
  final List<int> serverPublicKey;
  final SimpleKeyPair clientKeyPair;
  final List<int> clientKeySign;
  final dynamic message;
  bool initialized = false;

  LibAaryaPay(
      {required this.bVCertificate,
      required this.serverPublicKey,
      required this.clientKeyPair,
      required this.clientKeySign,
      required this.message,
      this.initialized = false});

  static Future<LibAaryaPay> createObject(
      {required List<int> bVCertificate,
      required List<int> serverPublicKey,
      required SimpleKeyPair clientKeyPair,
      required List<int> clientKeySign,
      required message}) async {
    SimplePublicKey publicKey =
        SimplePublicKey(serverPublicKey, type: KeyPairType.ed25519);

    Signature signatureKey = Signature(clientKeySign, publicKey: publicKey);
    final clientPublicKey = await clientKeyPair.extractPublicKey();
    bool verification =
        await algorithm.verify(clientPublicKey.bytes, signature: signatureKey);

    if (verification) {
      print("Public Key Verified");
      Signature signatureBalance =
          Signature(bVCertificate.sublist(24), publicKey: publicKey);
      verification = await algorithm.verify(bVCertificate.sublist(0, 24),
          signature: signatureBalance);

      if (verification) {
        print("Balance Verified");

        return LibAaryaPay(
          bVCertificate: bVCertificate,
          serverPublicKey: serverPublicKey,
          clientKeyPair: clientKeyPair,
          clientKeySign: clientKeySign,
          message: message,
          initialized: true,
        );
      }
    }
    return LibAaryaPay(
        bVCertificate: bVCertificate,
        serverPublicKey: serverPublicKey,
        clientKeyPair: clientKeyPair,
        clientKeySign: clientKeySign,
        message: message);
  }

  Future<List<int>> encodeMessage() async {
    if (initialized) {
      ByteData buffer = ByteData(20);

      buffer.setUint32(0, message["amount"]);
      buffer.setUint64(4, message["to"]);
      buffer.setUint64(12, message["to"] << 64);

      List<int> messageBuffer = buffer.buffer.asUint8List();
      messageBuffer = [...messageBuffer, ...bVCertificate];

      final signature =
          await algorithm.sign(messageBuffer, keyPair: clientKeyPair);

      final clientPublicKey = await clientKeyPair.extractPublicKey();
      final signedMessage = [
        ...messageBuffer,
        ...signature.bytes,
        ...clientPublicKey.bytes,
        ...clientKeySign
      ];

      return signedMessage;
    }
    throw ("Signature Verification Failed.");
  }

  Map<String, dynamic> decodeBalance() {
    if (initialized) {
      Map<String, dynamic> balanceCertificate = {};

      Uint8List balanceMessage =
          Uint8List.fromList(bVCertificate.sublist(0, 24));

      ByteData balanceByte = ByteData.view(balanceMessage.buffer);

      balanceCertificate["user_id"] = balanceByte.getInt64(8);
      balanceCertificate["user_id"] >> 64;
      balanceCertificate["user_id"] =
          balanceCertificate["user_id"] | balanceByte.getInt64(0);
      balanceCertificate["available_balance"] = balanceByte.getFloat32(16);
      balanceCertificate["time_stamp"] = balanceByte.getInt32(20);
      return balanceCertificate;
    }
    throw ("Signature Verification Failed.");
  }
}

Map<String, dynamic> balanceVerification = {
  "user_id": 1011,
  "available_balance": 100.11,
  "time_stamp": 1042134,
};

Map<String, dynamic> message = {
  "amount": 123,
  "to": 4817234,
  "balance_verification": balanceVerification
};

void main() async {
  final algorithm = Ed25519();
  ByteData buffer = ByteData(24);

  buffer.setUint64(0, message["balance_verification"]["user_id"]);
  buffer.setUint64(8, message["balance_verification"]["user_id"] << 64);

  buffer.setFloat32(16, message["balance_verification"]["available_balance"]);

  buffer.setUint32(20, message['balance_verification']["time_stamp"]);

  List<int> bytes = buffer.buffer.asUint8List();

  final serverKeyPair = await algorithm.newKeyPair();
  final serverPublicKey = await serverKeyPair.extractPublicKey();

  final clientKeyPair = await algorithm.newKeyPair();
  final clientPublicKey = await clientKeyPair.extractPublicKey();

  final signature = await algorithm.sign(bytes, keyPair: serverKeyPair);
  final clientPubSign =
      await algorithm.sign(clientPublicKey.bytes, keyPair: serverKeyPair);

  final balanceVerificationSignature = [
    ...bytes,
    ...signature.bytes,
  ];

  LibAaryaPay payment = await LibAaryaPay.createObject(
      bVCertificate: balanceVerificationSignature,
      serverPublicKey: serverPublicKey.bytes,
      clientKeyPair: clientKeyPair,
      clientKeySign: clientPubSign.bytes,
      message: message);

  final encodedMessage = await payment.encodeMessage();

  print(encodedMessage.length);

  print(payment.decodeBalance());

  //Check - Encoded Message

  Map<String, dynamic> balanceCertificate = {};

  Uint8List balanceMessage = Uint8List.fromList(encodedMessage.sublist(20, 44));

  ByteData balanceByte = ByteData.view(balanceMessage.buffer);

  balanceCertificate["user_id"] = balanceByte.getInt64(8);
  balanceCertificate["user_id"] >> 64;
  balanceCertificate["user_id"] =
      balanceCertificate["user_id"] | balanceByte.getInt64(0);
  balanceCertificate["available_balance"] = balanceByte.getFloat32(16);
  balanceCertificate["time_stamp"] = balanceByte.getInt32(20);

  Map<String, dynamic> messageDecoded = {};

  Uint8List decodedMessage = Uint8List.fromList(encodedMessage.sublist(0, 20));

  ByteData decodedByte = ByteData.view(decodedMessage.buffer);

  messageDecoded["amount"] = decodedByte.getInt32(0);
  messageDecoded["to"] = decodedByte.getInt64(12);
  messageDecoded["to"] >> 64;
  messageDecoded["to"] = messageDecoded["to"] | decodedByte.getInt64(4);
  messageDecoded["balance_verification"] = balanceCertificate;

  print(messageDecoded);
}
