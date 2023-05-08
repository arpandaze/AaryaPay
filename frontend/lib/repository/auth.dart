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

    // 401 : Email Wrong , Password Wrong, 202 : Accepted, 200 : Password Accept and Verified, Two FA Required, 403 : Unverified
    if (response.statusCode != 202) {
      var decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        storage.write(
          key: "two_FA",
          value: "true",
        );
        storage.write(
          key: "temp_token",
          value: response.headers["set-cookie"]!.substring(13, 49),
        );

        return {
          "response": decodedResponse,
          "mismatch": false,
          "verification": true,
          "two_fa_required": true,
        };
      }

      if (response.statusCode == 401) {
        storage.write(
          key: "user_id",
          value: jsonEncode(decodedResponse["user_id"]),
        );

        return {
          "response": decodedResponse,
          "mismatch": true,
          "verification": null,
          "two_fa_requir": null,
        };
      }

      if (response.statusCode == 403) {
        storage.write(
          key: "user_id",
          value: jsonEncode(decodedResponse["user_id"]),
        );
        return {
          "response": decodedResponse,
          "mismatch": false,
          "verification": false,
          "two_fa_required": null,
        };
      }
      throw Exception("Login Failed!");
    }

    var decodedResponse =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

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
    // storage.write(
    //     key: "private_key",
    //     value: base64Decode(decodedResponse["private_key"]).toString());

    return {
      "response": decodedResponse,
      "two_fa_required": false,
      "verification": true,
      "mismatch": false,
    };
  }

  Future<Object> logout() async {
    final url = Uri.parse('$backendBase/auth/logout');
    final token = await storage.read(key: "token");
    final headers = {
      "Cookie": "temp_session=; session=$token",
      "Content-Type": "application/json; charset=utf-8"
    };

    var response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      await storage.deleteAll();
      return {"logoutSuccess": true, "msg": "Logged out successfully!"};
    }
    return {"logoutSuccess": false, "msg": "Could not Log Out!"};
  }
}
