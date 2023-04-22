import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/favourite.dart';

class FavouriteApi{
  static Future<void> addFavourite(String id, String userId) async {
    try {
      await http.post(Uri.parse('$url/api/favourite/add-favourite'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"roomId": id, "userId": userId}));
    } catch (e) {
      // Handle any exceptions that may be thrown
      print('Error add favourite: $e');
    }
  }

  static Future<void> removeFavourite(String id, String userId) async {
    try {
      await http.delete(Uri.parse('$url/api/favourite/delete-favourite'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"roomId": id, "userId": userId}));
    } catch (e) {
      // Handle any exceptions that may be thrown
      print('Error remove favourite: $e');
    }
  }

  static Future<List<Favourite>> getFavourite(String userId) async {
    try {
      final response =
      await http.get(Uri.parse('$url/api/favourite/get-favourite/$userId'));
      var jsonObject = jsonDecode(response.body);
      var listObject = jsonObject as List;
      return listObject.map((e) => Favourite.fromJson(e)).toList();
    } catch (e) {
      print('Error get favourite: $e');
      return [];
    }
  }

  static Future checkFavourite(String id, String userId) async {
    try {
      final response = await http.post(
          Uri.parse('$url/api/favourite/check-favourite'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"roomId": id, "userId": userId}));
      return response;
    } catch (e) {
      // Handle any exceptions that may be thrown
      print('Error remove favourite: $e');
    }
  }
}