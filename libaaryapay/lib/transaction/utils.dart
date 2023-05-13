import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:libaaryapay/libaaryapay.dart';

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

payloadfromBase64(String base64) {
  return payloadfromBytes(base64Decode(base64));
}

payloadfromBytes(Uint8List bytes) {
  switch (bytes[0]) {
    case TAM_MESSAGE_TYPE:
      return TransactionAuthorizationMessage.fromBytes(bytes);
    case BKVC_MESSAGE_TYPE:
      return BalanceKeyVerificationCertificate.fromBytes(bytes);
    case TVC_MESSAGE_TYPE:
      return TransactionVerificationCertificate.fromBytes(bytes);
    default:
      throw Exception("Invalid Payload Type");
  }
}
