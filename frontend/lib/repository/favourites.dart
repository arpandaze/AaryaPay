import 'package:aaryapay/global/caching/favorite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
        "Content-Type": "application/json",
        "Cookie": "session=$token",
      };
      final response = await httpclient.get(Uri.parse('$backendBase/favorites'),
          headers: headers);

      if (response.statusCode != 200) {
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

  // Future<Favorite> getFavourites() async {

  // }

  Future<Map<String, dynamic>> getParticularUser({required String uuid}) async {
    if (token != null) {
      final headers = {
        "Content-Type": "application/json",
        "Cookie": "session=$token",
      };
      final response = await httpclient
          .get(Uri.parse('$backendBase/profile/$uuid'), headers: headers);

      if (response.statusCode != 200) {
        throw Exception("Retrieve Failed! Error getting user details.");
      }

      if (response.body.isNotEmpty) {
        var decodedResponse = jsonDecode(response.body);
        return decodedResponse;
      } else {
        throw Exception("User not found");
      }
    } else {
      throw Exception("No Session Found!!");
    }
  }

  Future<Map<String, dynamic>> postFavorites({required String email}) async {
    if (token != null) {
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Cookie": "session=$token",
      };
      final body = {
        "email": email,
      };
      final url = Uri.parse('$backendBase/favorites');
      var response = await httpclient.post(url,
          headers: headers, encoding: Encoding.getByName('utf-8'), body: body);
      if (response.statusCode != 201) {
        throw Exception("Post failed! Error adding to favorites list.");
      }
      if (response.body.isNotEmpty) {
        var decodedResponse = jsonDecode(response.body);
        return {"response": decodedResponse, "status": response.statusCode};
      } else {
        throw Exception("Empty");
      }
    } else {
      throw Exception("No Session Found!!");
    }
  }

  Future<Map<String, dynamic>> deleteFavorites({required String email}) async {
    if (token != null) {
      final headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Cookie": "session=$token",
      };
      final url = Uri.parse('$backendBase/favorites?email=$email');
      var response = await httpclient.delete(url, headers: headers);
      if (response.statusCode != 202) {
        throw Exception("Remove failed! Error removing favorites.");
      }
      if (response.body.isNotEmpty) {
        var decodedResponse = jsonDecode(response.body);
        return {"response": decodedResponse, "status": response.statusCode};
      } else {
        throw Exception("Empty");
      }
    } else {
      throw Exception("No Session Found!");
    }
  }
}
