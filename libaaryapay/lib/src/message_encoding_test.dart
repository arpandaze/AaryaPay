import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert';

import 'package:libaaryapay/src/main.dart';

import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class LibAaryaPay {
  final algorithm = Ed25519();
  final message;
  bool encode;
  final pubKey;
  final pubKeySignature;
  final verified = false;

  LibAaryaPay(
      {required this.message,
      required this.pubKey,
      required this.pubKeySignature,
      this.encode = true}) {
    await algorithm.verify(message, signature: messageSignature);
    this.verified = true;
  }

  Future<SimpleKeyPair> generateKeyPair() async {
    final keyPair = await algorithm.newKeyPair();
    return keyPair;
  }

  Future<Signature> sign(
      SimpleKeyPair privateKey, List<int> messagetoSign) async {
    final signature = await algorithm.sign(messagetoSign, keyPair: privateKey);
    return signature;
  }

  Future<bool> verify(Signature signature, List<int> messagetoSign) {
    return algorithm.verify(messagetoSign, signature: signature);
  }

  Future<List<int>> encoder() async {
    ByteData buffer = ByteData(24);

    buffer.setUint64(0, message["balance_verification"]["user_id"]);
    buffer.setUint64(8, message["balance_verification"]["user_id"] << 64);

    buffer.setFloat32(16, message["balance_verification"]["available_balance"]);

    buffer.setUint32(20, message['balance_verification']["time_stamp"]);

    List<int> bytes = buffer.buffer.asUint8List();

    final keypair = await generateKeyPair();
    final signature = await sign(keypair, bytes);

    final balanceVerificationSignature = [...bytes, ...signature.bytes];

    ByteData finalBuffer = ByteData(20);

    finalBuffer.setUint32(0, message["amount"]);
    finalBuffer.setUint64(4, message["to"]);
    finalBuffer.setUint64(12, message["to"] << 64);

    List<int> newBytes = finalBuffer.buffer.asUint8List();
    newBytes = [...newBytes, ...balanceVerificationSignature];

    final newKeyPair = await generateKeyPair();
    final newSignature = await sign(newKeyPair, newBytes);

    // backend signature required

    final pubKey = (await newKeyPair.extractPublicKey()).bytes;
    final signedMessage = [...newBytes, ...newSignature.bytes, ...pubKey];

    return signedMessage;
  }

  Map<String, dynamic> balanceDecoder() {
    return {};
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
  LibAaryaPay payment = LibAaryaPay(message: message);

  print((await payment.encoder()).length);
}
