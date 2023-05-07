import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/giphy_repository.dart';

class GiphyModel extends ChangeNotifier {
  List<dynamic> listCategories = [];
  List<dynamic> listTrending = [];
  Future getCategories() async {
    final data = await GiphyRepository.getCategories();
    listCategories = data;
    notifyListeners();
  }

  Future getGiphyByCategory(String category) async {
    listTrending = [];
    notifyListeners();
    final data = await GiphyRepository.getGiphyByCategory(category);
    listTrending = data;
    notifyListeners();
  }

  Future getTrending() async {
    final data = await GiphyRepository.getTrending();
    listTrending = data;
    notifyListeners();
  }
}
