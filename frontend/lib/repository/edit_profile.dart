import 'package:http/http.dart' as http;
import 'package:aaryapay/constants.dart';
import 'dart:convert';

class EditProfileRepository {
  final httpclient = http.Client();
  final String? token;

  EditProfileRepository({required this.token});

  Future<Map<String,dynamic>> getProfile() async {
    if (token != null) {
      final headers = {
        "Content-Type": "application/json",
        "Cookie": "session=$token",
      };
      final response = await httpclient.get(Uri.parse('$backendBase/profile'),
          headers: headers);

      if (response.statusCode != 200) {
        throw Exception("Retrieve Failed! Error getting profile details.");
      }

      if (response.body.isNotEmpty) {
        var decodedResponse = jsonDecode(response.body);
        return decodedResponse;
      } else {
        throw Exception("Profile Empty");
      }
    } else {
      throw Exception("No Session Found!!");
    }
  }
}
