import 'dart:convert';

import 'package:libaaryapay/BKVC.dart';
import 'package:libaaryapay/transaction.dart';
import 'package:libaaryapay/utils.dart';
import 'package:test/test.dart';

Future<void> main() async {
  test("Test Transaction", testTransaction);
  test("Test BKVC", testBKVC);
}

Future<void> testBKVC() async {
  final serverKeyPair = keyPairFromBase64(
    "fzAng9P5nxQCaxh4+sExTCdRI2++KmwBRKohfBJ8RuuD5sb/gfzu1BrFiJeGJudEOwAp1ZVekbVwWrLmRlzu1g==",
  );

  final testBKVCBytes = base64Decode(
    "UfE7C9UHRTCEanXu6S6UakLIAACh6ApULfYJv0mi1hs1FtXS0+ELUPNFc9wIVvX2RD8sKWREB4o/FRmulobhFmb2SuqTzhMnnqGcpEWDw36ZGnxwmSv36JbVyCGk68iz16tvPGQ+g3gBhSsGIJtiEdTMcJNoU/MJ",
  );

  final testBKVC = BalanceKeyVerificationCertificate.fromBytes(testBKVCBytes);

  assert(await testBKVC.verify(await serverKeyPair.extractPublicKey()));
}

Future<void> testTransaction() async {
  final serverKeyPair = keyPairFromBase64(
    "fzAng9P5nxQCaxh4+sExTCdRI2++KmwBRKohfBJ8RuuD5sb/gfzu1BrFiJeGJudEOwAp1ZVekbVwWrLmRlzu1g==",
  );

  final testKeyPair = keyPairFromBase64(
    "WVALpaXliHBZ+FT9+60jxODq3IhwMv7vNEzBc8jjsEqh6ApULfYJv0mi1hs1FtXS0+ELUPNFc9wIVvX2RD8sKQ==",
  );

  final testTransactionBytes = base64Decode(
    "QSAAAL9DPVgyw04Gn9WR+95OzIZR8TsL1QdFMIRqde7pLpRqQsgAAKHoClQt9gm/SaLWGzUW1dLT4QtQ80Vz3AhW9fZEPywpZEQHij8VGa6WhuEWZvZK6pPOEyeeoZykRYPDfpkafHCZK/foltXIIaTryLPXq288ZD6DeAGFKwYgm2IR1Mxwk2hT8wlkRAeKcMTexbO/Hus5rQTcEl1a6UBZcE5lHdxyjoDC8rXqHhJl8UXMSbwNp3qc3j56W63k7V/gmeBiey8YnNMqg4UfDw==",
  );

  final testTransaction = Transaction.fromBytes(testTransactionBytes);

  assert(await testTransaction.verify(await testKeyPair.extractPublicKey()));
  assert(await testTransaction.bkvc
      .verify(await serverKeyPair.extractPublicKey()));
}
