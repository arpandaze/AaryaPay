import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:aaryapay/constants.dart';
import 'package:libaaryapay/BKVC.dart';

class AuthenticationRepository {
  final client = http.Client();

  static const storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    final url = Uri.parse('$backendBase/auth/login');
    print(url);

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        "email": email,
        "password": password,
        "remember_me": "true",
      },
    );

    if (response.statusCode != 202) {
      throw Exception("Login Failed! Check Email or Password!");
    }

    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    print(decodedResponse);

    if (decodedResponse["two_fa_required"] == true) {
      return {"two_fa_required": true};
    } else {
      var bkvc = base64Decode(decodedResponse["bkvc"]);

      BalanceKeyVerificationCertificate bkvcObject =
          BalanceKeyVerificationCertificate.fromBytes(bkvc);

      print(response.headers["set_cookie"]!);
      storage.write(
        key: "token",
        value: response.headers["set-cookie"]!.substring(8, 40),
      );

      storage.write(key: "user_id", value: bkvcObject.userID.toString());
      storage.write(
          key: "available_balance",
          value: bkvcObject.availableBalance.toString());
      storage.write(key: "public_key", value: bkvcObject.publicKey.toString());
      storage.write(key: "timestamp", value: bkvcObject.timeStamp.toString());
      storage.write(key: "signature", value: bkvcObject.signature.toString());
      storage.write(
          key: "private_key",
          value: base64Decode(decodedResponse["private_key"]).toString());

      print(await storage.readAll());
      return {"response": decodedResponse, "two_fa_required": false};
    }
  }

  Future<Object> logout() async {
    await storage.deleteAll();
    return "Logged out successfully!";
  }
}
