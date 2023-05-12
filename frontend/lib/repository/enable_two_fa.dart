import 'package:http/http.dart' as http;
import 'package:aaryapay/constants.dart';
import 'dart:convert';

class TwoFARepository {
  final client = http.Client();
  final String? token;
  TwoFARepository({
    required this.token,
  });

  Future<Map<String, dynamic>> getTwoFA() async {
    if (token != null) {
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Cookie": "session=$token",
      };
      final response = await client.get(
        Uri.parse('$backendBase/auth/twofa/enable/request'),
        headers: headers,
      );

      if (response.statusCode != 202) {
        if (response.statusCode == 409) {
          throw Exception("TwoFA is already enabled");
        }
        throw Exception("Retrieve Failed! Error enabling TwoFA request.");
      }

      if (response.body.isNotEmpty) {
        var decodedResponse = jsonDecode(response.body);
        return decodedResponse;
      } else {
        throw Exception("Response empty");
      }
    } else {
      throw Exception("No Session Found!!");
    }
  }

  Future<Map<String, dynamic>> enableTwoFA({required String code}) async {
    if (token != null) {
      final headers = {
        "Cookie": "session=$token",
        "Content-Type": "application/x-www-form-urlencoded"
      };
      var response = await client.post(
        Uri.parse('$backendBase/auth/twofa/enable/confirm'),
        headers: headers,
        body: {
          "passcode": code,
        },
      );

      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode != 202) {
        throw Exception("Unknown error occured");
      }

      if (response.body.isNotEmpty) {
        return {"response": decodedResponse, "status": response.statusCode};
      } else {
        throw Exception("Body Empty!");
      }
    } else {
      throw Exception("Session not found!");
    }
  }

  Future<Map<String, dynamic>> disableTwoFA() async {
    if (token != null) {
      final headers = {
        "Cookie": "session=$token",
        "Content-Type": "application/x-www-form-urlencoded"
      };
      var response = await client.post(
        Uri.parse('$backendBase/auth/twofa/disable'),
        headers: headers,
      );

      var decodedResponse = jsonDecode(response.body);

      print(response.statusCode);
      if (response.statusCode != 202) {
        throw Exception("Unknown error occured");
      }

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
