import 'dart:convert';
import 'dart:ffi';

import 'package:cryptography/cryptography.dart';
import 'package:libaaryapay/BKVC.dart';
import 'package:libaaryapay/TVC.dart';
import 'package:libaaryapay/transaction.dart';
import 'package:libaaryapay/utils.dart';
import 'package:test/test.dart';

Future<void> main() async {
  test("Test Transaction", testTransaction);
  test("Test BKVC", testBKVC);
  test("Test TVC", testTVC);
}

Future<void> testBKVC() async {
  final serverKeyPair = keyPairFromBase64(
    "fzAng9P5nxQCaxh4+sExTCdRI2++KmwBRKohfBJ8RuuD5sb/gfzu1BrFiJeGJudEOwAp1ZVekbVwWrLmRlzu1g==",
  );

  final testBKVCBytes = base64Decode(
    "AgDsY4+ew0nvivGNkQHPt+NCyAAAJ64Og8584ZT6pcGqSNvuuOvfJqWkfO5UfG4p3mhrn9RkTT89ScYXj3lJkWUmDP0h8Z53J/MG62EkRZnQaGCc7wZnuJ7o3LMuDlfW1SyyG6U8bkUh98PSGMESuQCPhxoDE96eBA==",
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
    "AUEgAABRZpp8YNFDOLP935oC3Fi2AoQca1GxKEuKrq02mrltN/9CyAAAQyFip62yQH8WPYd8Dx+t9oMAmgMFq7+R2QgDBaLeyVFkTUgTq0ndxE3GrBDm3zGZt24OWWXinxds+m4nHA1OtXKnzncmS5npG2jomZFu5G8isXtz8zgEEFpoFvZ6aXGmM7C7CGRNSBMDjaHL44Mwpwx9EexLN/QvvEPytkuoBAf/R874od6GFhTe+coVlmigw9BdcMel4+8wnOzKp5ncyWWCoshapAcP",
  );

  final userKeyPair = keyPairFromBase64(
      "KonM+eOMRiRH6HQ97ldGyxu+dhq0ESjeesL/nD/I9aVDIWKnrbJAfxY9h3wPH632gwCaAwWrv5HZCAMFot7JUQ==");

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
    "A102rNijgAoEtD+K0ABj14i7mhKg+YeAyhk4EXJeumvUbwChFsGnP6Y5u6oplJIknUwSaeRsWGuthClNCnlj7AdTp9M7ksdHF69KyDktxbsEAgFdx/RO3UhRq4GtAZ1akc1CyAAAkxw76kIrxQbPXwHzV4YuIj4tpVcYrOsfUmhTpq6S4yhkTUnMGpUorLfNav7R6O/+VYyP4bCOBkCRkom8rxmBR5ryBDQo3nvpT5q5Ul7/kruH+C4JSl668jpcIYxZjcnXF7U6BODir+ebu4JtvtHUcT/w4VPRYl1783mh24HNWISPFMb7ba8Tus0OKSL08eK+kavHTyHt05H/Jc+gE2OFdzHXFww=",
  );

  final testTVC = TransactionVerificationCertificate.fromBytes(
    testTVCBytes,
  );

  assert(await testTVC.verify(await serverKeyPair.extractPublicKey()));
  assert(await testTVC.bkvc.verify(await serverKeyPair.extractPublicKey()));

  var remakeTransaction = TransactionVerificationCertificate(
    testTVC.messageType,
    testTVC.transactionSignature,
    testTVC.transactionID,
    testTVC.bkvc,
  );

  await remakeTransaction.sign(serverKeyPair);

  assert(
    await remakeTransaction.verify(await serverKeyPair.extractPublicKey()),
  );

  assert(
    await remakeTransaction.bkvc.verify(await serverKeyPair.extractPublicKey()),
  );
}
