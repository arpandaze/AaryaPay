import 'package:http/http.dart' as http;
import 'package:aaryapay/constants.dart';
import 'dart:convert';

class RegisterRepository {
  final client = http.Client();
  Future<Map<String, dynamic>> register(
      {required String firstName,
      String? middleName,
      required String lastName,
      required String dob,
      required String email,
      required String password}) async {
    final url = Uri.parse('$backendBase/auth/register');
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        "first_name": firstName,
        "middle_name": middleName,
        "last_name": lastName,
        "dob": dob,
        "email": email,
        "password": password
      },
    );

    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
    return decodedResponse;
  }
}
