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

    print("Hello ${response.statusCode}");

    if (response.statusCode != 202) {
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

      storage.write(key: "user_id", value: bkvcObject.userID.toString());

      return {"response": decodedResponse, "two_fa_required": false};
    }
  }
}
