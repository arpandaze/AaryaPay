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
    print("Upwards Here I am");

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
      if (response.statusCode == 401) {
        var decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        return {"response": decodedResponse, "verification": false};
      }
      throw Exception("Login Failed! Check Email or Password!");
    }

    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (decodedResponse["two_fa_required"] == true) {
      return {"two_fa_required": true};
    } else {
      var bkvc = base64Decode(decodedResponse["bkvc"]);

      BalanceKeyVerificationCertificate bkvcObject =
          BalanceKeyVerificationCertificate.fromBytes(bkvc);

      storage.write(
        key: "token",
        value: response.headers["set-cookie"]!.substring(8, 44),
      );

      storage.write(key: "user", value: jsonEncode(decodedResponse["user"]));
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

      return {
        "response": decodedResponse,
        "two_fa_required": false,
        "verification": true,
      };
    }
  }

  Future<Object> logout() async {
    await storage.deleteAll();
    return "Logged out successfully!";
  }
}
