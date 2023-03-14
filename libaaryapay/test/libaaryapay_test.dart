import 'package:libaaryapay/libaaryapay.dart';
import "dart:convert";

void main() async{
  final keyPair =  await LibAaryaPay().generateKeyPair();
  final message = "Hello";
  final encodedMessage = utf8.encode(message);

  final signature = await LibAaryaPay().sign(encodedMessage, keyPair);

  print("Message: $message");
  print("Signature: ${signature.bytes}");

  final isValid = await LibAaryaPay().verify(encodedMessage, signature);

  print("Validity: $isValid");
}
