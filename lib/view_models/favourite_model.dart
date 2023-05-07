
import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/favourite_repository.dart';

import '../models/favourite.dart';

class FavouriteModel extends ChangeNotifier {
  bool isCheckFavourite = false;

  Future<void> addFavourite(String id, String userId) async {
    await FavouriteRepository.addFavourite(id, userId);
  }

  Future<void> removeFavourite(String id, String userId) async {
    await FavouriteRepository.removeFavourite(id, userId);
    getFavourite(userId);
  }

  Future<List<Favourite>> getFavourite(String userId) async {
    return await FavouriteRepository.getFavourite(userId);
  }

  Future<void> checkFavourite(String id, String userId) async {
      final response = await FavouriteRepository.checkFavourite(id, userId);
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
