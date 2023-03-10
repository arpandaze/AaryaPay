import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class LibAaryaPay {
  final algorithm = Ed25519();

  Future<SimpleKeyPair> generateKeyPair() async {
    final keyPair = await algorithm.newKeyPair();
    return keyPair;
  }

  Future<Signature> sign(List<int> message, SimpleKeyPair privateKey) async {
    final signature = await algorithm.sign(message, keyPair: privateKey);
    return signature;
  }

  Future<bool> verify(List<int> message, Signature signature) {
    return algorithm.verify(message, signature: signature);
  }
}
