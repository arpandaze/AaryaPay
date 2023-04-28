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
    "Ai6WGyf1J0z0vB1YBGzxk98AAAAANzr5BEKFxEvx16S4cu+TY7aUOgn9Bvhw+E0vYE7z419kS9tdRNIqeCxAjRBxLl4bWda1kRS2MfEQ0z/IHBsGsDgCR1tmV3swsIoVqGShFPL6GQQLleCgapF2cg86QPywl6uJBw==",
  );

  final testBKVC = BalanceKeyVerificationCertificate.fromBytes(testBKVCBytes);

  assert(await testBKVC.verify(await serverKeyPair.extractPublicKey()));
}

Future<void> testTransaction() async {
  final serverKeyPair = keyPairFromBase64(
    "fzAng9P5nxQCaxh4+sExTCdRI2++KmwBRKohfBJ8RuuD5sb/gfzu1BrFiJeGJudEOwAp1ZVekbVwWrLmRlzu1g==",
  );

  final testTransactionBytes = base64Decode(
    "AUEgAAC56GZcvRhIrourUf7WeckVAmZkttpjqks2ie162wh5ZUZCyAAAglxKzHN0/BaXkZ6nCHJlpCAGfOa7WzPXpsMg/5JZXY1kS+w3PCHmbHmY6rzbHS0QDQJ+1Rci5o+7hfnZugDm7ilgDKXimrcA8sfm/MF/9wFIE/fD0w/oJPomYla+c5SpTBnjA2RL7DcAS8PqTcWzmNrAoexZ8Zkxa1p28GhQqNP1D4JpouoNYgYL1uVwhJkj4Dc/d1KQpJy9N0iLXF7RQL0GoNh4N4QI",
  );

  final testTransaction = Transaction.fromBytes(testTransactionBytes);

  assert(await testTransaction.bkvc
      .verify(await serverKeyPair.extractPublicKey()));

  assert(await testTransaction.verify());
}
