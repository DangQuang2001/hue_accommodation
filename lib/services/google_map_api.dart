import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

class GoogleMapApi {
  static Future<String?> placeAutocomplete(String query) async {
    String apiUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String apiKey = 'AIzaSyCFMB3KVGNeKYmIgcYh8Wv1At2_wyoTrMU';
    try {
      final response =
          await http.get(Uri.parse('$apiUrl?input=$query&key=$apiKey'));

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  static Future getSearchResultsFromQueryUsingMapbox(String query) async {
    List parsedResponses = [];
    String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
    String accessToken =
        'pk.eyJ1IjoicXVhbmdyYzIwMDEiLCJhIjoiY2xndWpwdWM4MGc3ZDNmbnVtdWpwdGFvdSJ9.RQiUeUHOwMsjYc56dRtpgw';
    String searchType = 'place%2Cpostcode%2Caddress';
    String searchResultsLimit = '5';
    String country = 'vn';
    String proximity = '${107.590866}%2C${16.463713}';
    String url =
        '$baseUrl/$query.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken&autocomplete=true';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body)['features'];
    for (var feature in data) {
      Map responses = {
        'name': feature['text'],
        'address': feature['place_name'].split('${feature['text']}, ')[1],
        'place': feature['place_name']
      };
      parsedResponses.add(responses);
    }
    print(response.body);
  }

  static Future getPlace(String query) async {
    String apiUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json';
    String apiKey = 'AIzaSyCFMB3KVGNeKYmIgcYh8Wv1At2_wyoTrMU';
    try {
      final response =
          await http.get(Uri.parse('$apiUrl?query=$query&key=$apiKey'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['results'] as List<dynamic>;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

//
