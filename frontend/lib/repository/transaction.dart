import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:aaryapay/constants.dart';
import 'dart:convert';

class TransactionRepository {
  final httpclient = http.Client();
  static const storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> getTransactions() async {
    var token = await storage.read(key: "token");
    if (token != null) {
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Cookie": "session=$token",
      };

      final response = await httpclient
          .get(Uri.parse('$backendBase/transaction'), headers: headers);
      print(response.statusCode);
      if (response.statusCode != 200) {
        throw Exception("Retrieve Failed! Error getting statement list.");
      }

      if (response.body.isNotEmpty) {
        var decodedResponse = jsonDecode(response.body);
        return decodedResponse;
      } else {
        throw Exception("Transcation Empty");
      }
    } else {
      throw Exception("No Session Found!!");
    }
  }
}
