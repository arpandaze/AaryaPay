import 'dart:convert';

import 'package:cryptography/cryptography.dart';

SimpleKeyPair keyPairFromBase64(String privateKeyBase64) {
  final keyPairBytes = base64.decode(privateKeyBase64);

  final type = KeyPairType.ed25519;
  final publicKeyBytes = keyPairBytes.sublist(32);

  final privKeyBytes = keyPairBytes.sublist(0, 32);
  final publicKey = SimplePublicKey(publicKeyBytes, type: type);

  return SimpleKeyPairData(privKeyBytes, publicKey: publicKey, type: type);
}

SimplePublicKey publicKeyFromBase64(String publicKeyBase64) {
  final publicKeyBytes = base64.decode(publicKeyBase64);

  final type = KeyPairType.ed25519;

  return SimplePublicKey(publicKeyBytes, type: type);
}
