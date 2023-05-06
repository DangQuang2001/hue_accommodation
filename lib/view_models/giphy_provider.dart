import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/giphy_api.dart';

class GiphyProvider extends ChangeNotifier {
  List<dynamic> listCategories = [];
  List<dynamic> listTrending = [];
  Future getCategories() async {
    final data = await GiphyApi.getCategories();
    listCategories = data;
    notifyListeners();
  }

  Future getGiphyByCategory(String category) async {
    listTrending = [];
    notifyListeners();
    final data = await GiphyApi.getGiphyByCategory(category);
    listTrending = data;
    notifyListeners();
  }

  Future getTrending() async {
    final data = await GiphyApi.getTrending();
    listTrending = data;
    notifyListeners();
  }
}
