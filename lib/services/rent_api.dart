import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/rent.dart';

class RentApi{
  static Future createRent(
      String hostID,
      String userID,
      String name,
      String image,
      String roomImage,
      String phone,
      String roomID,
      String roomName,
      int numberDaysRented,
      int numberPeople,
      String notes) async {
    final response = await http.post(Uri.parse('$url/api/rent/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "dateCreate": DateTime.now().toString(),
          "hostID": hostID,
          "userID": userID,
          "name": name,
          "image":image,
          "roomImage":roomImage,
          "phone": phone,
          "roomID": roomID,
          "roomName": roomName,
          "numberDaysRented": numberDaysRented,
          "numberPeople": numberPeople,
          "note": notes,
          "isConfirmed": 0,
        }));
    return response;
  }

  static Future<List<Rent>> getListWaiting(String hostId,int isConfirmed) async {
    final response = await http.get(Uri.parse('$url/api/rent/waiting/$hostId/$isConfirmed'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    return listObject.map((e) => Rent.fromJson(e)).toList();
  }

  static Future<List<Rent>> getListConfirm(String hostId,int isConfirmed) async {
    final response = await http.get(Uri.parse('$url/api/rent/waiting/$hostId/$isConfirmed'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    return listObject.map((e) => Rent.fromJson(e)).toList();
  }

  static Future<List<Rent>> getListUnConfirm(String hostId,int isConfirmed) async {
    final response = await http.get(Uri.parse('$url/api/rent/waiting/$hostId/$isConfirmed'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    return listObject.map((e) => Rent.fromJson(e)).toList();
  }

  static Future<void> confirm(String hostId,String id) async {
    await http.get(Uri.parse('$url/api/rent/confirm/$id'));
  }

  static Future<void> unConfirm(String hostId,String id) async {
    await http.get(Uri.parse('$url/api/rent/unconfirm/$id'));
  }

  static Future<List<Rent>> getListRent(String userId) async {
    final response = await http.get(Uri.parse('$url/api/rent/rentuser/$userId'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    return listObject.map((e) => Rent.fromJson(e)).toList();

  }
}