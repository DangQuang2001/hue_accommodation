import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:hue_accommodation/services/favourite_api.dart';

import '../models/favourite.dart';

class FavouriteProvider extends ChangeNotifier {
  bool isCheckFavourite = false;

  Future<void> addFavourite(String id, String userId) async {
    await FavouriteApi.addFavourite(id, userId);
  }

  Future<void> removeFavourite(String id, String userId) async {
    await FavouriteApi.removeFavourite(id, userId);
    getFavourite(userId);
  }

  Future<List<Favourite>> getFavourite(String userId) async {
    return await FavouriteApi.getFavourite(userId);
  }

  Future<void> checkFavourite(String id, String userId) async {
      final response = await FavouriteApi.checkFavourite(id, userId);
      if (response.statusCode == 200) {
        isCheckFavourite = true;
        notifyListeners();
      }
      if (response.statusCode == 201) {
        isCheckFavourite = false;
        notifyListeners();
      }
  }
}
