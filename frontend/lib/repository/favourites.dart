import 'package:http/http.dart' as http;
import 'package:aaryapay/constants.dart';
import 'dart:convert';

class FavouritesRepository {
  final httpclient = http.Client();
  final String? token;

  FavouritesRepository({required this.token});

  Future<Map<String, dynamic>> getFavourites() async {
    if (token != null) {
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Cookie": "session=$token",
      };
      final response = await httpclient.get(Uri.parse('$backendBase/favorites'),
          headers: headers);

      if (response.statusCode != 202) {
        throw Exception("Retrieve Failed! Error getting favorites list.");
      }

      if (response.body.isNotEmpty) {
        var decodedResponse = jsonDecode(response.body);
        return decodedResponse;
      } else {
        throw Exception("Favourites Empty");
      }
    } else {
      throw Exception("No Session Found!!");
    }
  }
}
