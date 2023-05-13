import 'package:http/http.dart' as http;
import 'package:aaryapay/constants.dart';
import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class EditProfileRepository {
  final httpclient = http.Client();
  final String? token;

  EditProfileRepository({required this.token});

  Future<Map<String, dynamic>> getProfile() async {
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
        return decodedResponse['data'];
      } else {
        throw Exception("Profile Empty");
      }
    } else {
      throw Exception("No Session Found!!");
    }
  }

  Future<Map> editPersonal({required Map body}) async {
    if (token != null) {
      var uri = Uri.parse('$backendBase/profile');
      var request = http.MultipartRequest(
        'PATCH',
        uri,
      )
        ..fields['first_name'] = body['first_name']
        ..fields['middle_name'] = body['middle_name']
        ..fields['last_name'] = body['last_name']
        ..fields['dob'] = body['dob'];

      request.headers['Cookie'] = "session=$token";

      var response = await request.send();

      if (response.statusCode == 202) {
        var responseBody = await response.stream.bytesToString();
        if (responseBody.isNotEmpty) {
          var decodedResponse = jsonDecode(responseBody);
          return decodedResponse;
        } else {
          throw Exception("Body Empty");
        }
      } else {
        throw Exception("Submit Failed");
      }
    } else {
      throw Exception("No Session found!!");
    }
  }

  Future<Map> uploadProfile({required String imagePath}) async {
    var uri = Uri.parse("$backendBase/profile/photo");
    var request = http.MultipartRequest('PATCH', uri);
    request.files.add(
      await http.MultipartFile.fromPath(
        "photo",
        imagePath,
        contentType: MediaType.parse(
          lookupMimeType(imagePath)!,
        ),
      ),
    );

    request.headers['Cookie'] = "session=$token";
    var response = await request.send();
    if (response.statusCode == 202) {
      var responseBody = await response.stream.bytesToString();
      if (responseBody.isNotEmpty) {
        var decodedResponse = jsonDecode(responseBody);
        return decodedResponse;
      } else {
        throw Exception("Body Empty");
      }
    } else {
      throw Exception("Submit Failed");
    }
  }
}
