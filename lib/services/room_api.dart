import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/review.dart';

class RoomApi{
  static Future<bool> reviewRoom(String roomId,String userId,double rating,String comment,List<String> images) async {
    final response = await http.post(Uri.parse('$url/api/motelhouse/review-room'),
        headers: <String, String>{
          'Content-Type':
          'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "roomId":roomId,
          "userId":userId,
          "rating":rating,
          "comment":comment,
          "images":images
        }));
    if(response.statusCode == 200){
      return true;
    }
    if(response.statusCode == 403){
      return false;
    }
    return false;
  }

  static Future getReview(String roomId) async {
    final response = await http.get(Uri.parse('$url/api/motelhouse/get-review/$roomId'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    if(response.statusCode == 200){
      return listObject.map((e) => Review.fromJson(e)).toList();
    }
    if(response.statusCode == 403){
      return [];
    }
    return [];
  }
}