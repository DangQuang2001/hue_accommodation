import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

class GoogleMapApi {
  static Future<String?> placeAutocomplete(String query) async {
    String apiUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String apiKey = 'AIzaSyAL7M2Av95H-dCLtQTMxAv5B-KzMiJcO9Y';
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
}

//