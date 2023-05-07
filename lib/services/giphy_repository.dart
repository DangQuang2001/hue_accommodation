import 'dart:convert';

import 'package:http/http.dart' as http;

class GiphyRepository {
  static Future<List<dynamic>> getCategories() async {
    String url =
        "https://api.giphy.com/v1/gifs/categories?api_key=RpxcqjKAUXAZPjZlGq7jrldFzzQxo5Vj&limit=10";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getTrending() async {
    String url =
        "https://api.giphy.com/v1/gifs/trending?api_key=RpxcqjKAUXAZPjZlGq7jrldFzzQxo5Vj&limit=10";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return [];
    }
  }

  static Future<List<dynamic>> getGiphyByCategory(String category) async {
    String url =
        "https://api.giphy.com/v1/gifs/search?q=$category&api_key=RpxcqjKAUXAZPjZlGq7jrldFzzQxo5Vj&limit=10";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      return [];
    }
  }
}
