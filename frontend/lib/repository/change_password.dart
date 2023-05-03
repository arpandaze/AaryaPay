import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:aaryapay/constants.dart';

class PasswordRepository {
  final Client httpclient = http.Client();
  final String? token;

  PasswordRepository({this.token});

  Future<Map> changePassword({required Map body}) async {
    if (token != null) {
      final headers = {
        "Cookie": "session=$token",
        "Content-Type": "application/json"
      };
      var response = await httpclient.post(
        Uri.parse('$backendBase/auth/password-change'),
        headers: headers,
        body: jsonEncode(body),
      );

      var decodedResponse = jsonDecode(response.body);

      if (response.body.isNotEmpty) {
        return {"response": decodedResponse, "status": response.statusCode};
      } else {
        throw Exception("Body Empty!");
      }
    } else {
      throw Exception("Session not found!");
    }
  }
}
