import 'dart:convert';

import 'package:libaaryapay/libaaryapay.dart';
import 'package:test/test.dart';

Future<void> main() async {
  test("Test BKVC", testBKVC);
  test("Test TAM", testTransaction);
  test("Test TVC", testTVC);
  test("Test Payload", testPayload);
}

Future<void> testBKVC() async {
  final serverKeyPair = keyPairFromBase64(
    "fzAng9P5nxQCaxh4+sExTCdRI2++KmwBRKohfBJ8RuuD5sb/gfzu1BrFiJeGJudEOwAp1ZVekbVwWrLmRlzu1g==",
  );

  final testBKVCBytes = base64Decode(
    "ApR8lY4DsEl2n7WpTy92YY5CyAAAJpH+8tTT1G4Jn7HL5cfbZK7xGOalOodoIDeCmxY6WmNkXRtpXH9CGO7WhD/ofo2oav0Q7p+xp0em0cv73P0eN0mrsy3VvCc5E69kGUEOUR3I4ENWXEAymA8ifkIBjqqzG2skBA==",
  );

  final testBKVC = BalanceKeyVerificationCertificate.fromBytes(testBKVCBytes);

  assert(await testBKVC.verify(await serverKeyPair.extractPublicKey()));

  testBKVC.verify(await serverKeyPair.extractPublicKey());

  var remakeBKVC = BalanceKeyVerificationCertificate(
    testBKVC.messageType,
    testBKVC.userID,
    testBKVC.availableBalance,
    testBKVC.publicKey,
    testBKVC.timeStamp,
  );

  await remakeBKVC.sign(serverKeyPair);
  assert(await remakeBKVC.verify(await serverKeyPair.extractPublicKey()));
}

Future<void> testTransaction() async {
  final serverKeyPair = keyPairFromBase64(
    "fzAng9P5nxQCaxh4+sExTCdRI2++KmwBRKohfBJ8RuuD5sb/gfzu1BrFiJeGJudEOwAp1ZVekbVwWrLmRlzu1g==",
  );

  final testTransactionBytes = base64Decode(
    "AUEgAADQ0AoBp31DMag6CJw2HyuIApR8lY4DsEl2n7WpTy92YY5CyAAAJpH+8tTT1G4Jn7HL5cfbZK7xGOalOodoIDeCmxY6WmNkXRtpXH9CGO7WhD/ofo2oav0Q7p+xp0em0cv73P0eN0mrsy3VvCc5E69kGUEOUR3I4ENWXEAymA8ifkIBjqqzG2skBGRdG2nlTPKjNJHPm8ZjGHCzSVLRUNYJsBHJ40E7LdVBWSSLACRJl71U8dxSKA15uP1y1gj1KEe05bPduu6Ebdh6TcwA",
  );

  final userKeyPair = keyPairFromBase64(
    "GgYzFdDJ0ODfkhZVIrrg8wvEI3njc43caDzSP34IlR8mkf7y1NPUbgmfscvlx9tkrvEY5qU6h2ggN4KbFjpaYw==",
  );

  final testTransaction = Transaction.fromBytes(testTransactionBytes);

  assert(
    await testTransaction.bkvc.verify(await serverKeyPair.extractPublicKey()),
  );

  assert(await testTransaction.verify());

  var remakeTransaction = Transaction(
    testTransaction.messageType,
    testTransaction.amount,
    testTransaction.to,
    testTransaction.bkvc,
    testTransaction.timeStamp,
  );

  await remakeTransaction.sign(userKeyPair);

  assert(
    await remakeTransaction.verify(),
  );

  assert(
    await remakeTransaction.bkvc.verify(await serverKeyPair.extractPublicKey()),
  );
}

Future<void> testTVC() async {
  final serverKeyPair = keyPairFromBase64(
    "fzAng9P5nxQCaxh4+sExTCdRI2++KmwBRKohfBJ8RuuD5sb/gfzu1BrFiJeGJudEOwAp1ZVekbVwWrLmRlzu1g==",
  );

  final testTVCBytes = base64Decode(
    "A0EgAABjv1hq/fRNa6UJC9E87kneApR8lY4DsEl2n7WpTy92YY5CyAAAJpH+8tTT1G4Jn7HL5cfbZK7xGOalOodoIDeCmxY6WmNkXRtpXH9CGO7WhD/ofo2oav0Q7p+xp0em0cv73P0eN0mrsy3VvCc5E69kGUEOUR3I4ENWXEAymA8ifkIBjqqzG2skBGRdG2kDZdS4MrfBnTbzmQhH0X1QaVNpNpyldYUt3oo2lnFs7NVJ3yjDf+Rv1Fodf6rJqQ/d/hPrVpc9cNVQgW5UmCAM",
  );

  final testTVC = TransactionVerificationCertificate.fromBytes(
    testTVCBytes,
  );

  assert(await testTVC.verify(await serverKeyPair.extractPublicKey()));
  assert(await testTVC.bkvc.verify(await serverKeyPair.extractPublicKey()));

  var remakeTransaction = TransactionVerificationCertificate(
    testTVC.messageType,
    testTVC.amount,
    testTVC.from,
    testTVC.bkvc,
    testTVC.timeStamp,
  );

  await remakeTransaction.sign(serverKeyPair);

  assert(
    await remakeTransaction.verify(await serverKeyPair.extractPublicKey()),
  );

  assert(
    await remakeTransaction.bkvc.verify(await serverKeyPair.extractPublicKey()),
  );
}

Future<void> testPayload() async {
  final sampleTVC =
      "A0EgAABjv1hq/fRNa6UJC9E87kneApR8lY4DsEl2n7WpTy92YY5CyAAAJpH+8tTT1G4Jn7HL5cfbZK7xGOalOodoIDeCmxY6WmNkXRtpXH9CGO7WhD/ofo2oav0Q7p+xp0em0cv73P0eN0mrsy3VvCc5E69kGUEOUR3I4ENWXEAymA8ifkIBjqqzG2skBGRdG2kDZdS4MrfBnTbzmQhH0X1QaVNpNpyldYUt3oo2lnFs7NVJ3yjDf+Rv1Fodf6rJqQ/d/hPrVpc9cNVQgW5UmCAM";

  final sampleBKVC =
      "ApR8lY4DsEl2n7WpTy92YY5CyAAAJpH+8tTT1G4Jn7HL5cfbZK7xGOalOodoIDeCmxY6WmNkXRtpXH9CGO7WhD/ofo2oav0Q7p+xp0em0cv73P0eN0mrsy3VvCc5E69kGUEOUR3I4ENWXEAymA8ifkIBjqqzG2skBA==";

  final sampleTransaction =
      "AUEgAABRZpp8YNFDOLP935oC3Fi2AoQca1GxKEuKrq02mrltN/9CyAAAQyFip62yQH8WPYd8Dx+t9oMAmgMFq7+R2QgDBaLeyVFkTUgTq0ndxE3GrBDm3zGZt24OWWXinxds+m4nHA1OtXKnzncmS5npG2jomZFu5G8isXtz8zgEEFpoFvZ6aXGmM7C7CGRNSBMDjaHL44Mwpwx9EexLN/QvvEPytkuoBAf/R874od6GFhTe+coVlmigw9BdcMel4+8wnOzKp5ncyWWCoshapAcP";

  var payload = payloadfromBase64(sampleBKVC);
  var payload2 = payloadfromBase64(sampleTVC);
  var payload3 = payloadfromBase64(sampleTransaction);

  assert(payload is BalanceKeyVerificationCertificate);
  assert(payload2 is TransactionVerificationCertificate);
  assert(payload3 is Transaction);
}
