import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/rent.dart';

class RentApi{
  static Future<bool> createRent(
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
    if (response.statusCode == 200) {
      createNotification(userID,"đã đăng ký thuê phòng!", 1, hostID, "");

      return true;
    }
    if (response.statusCode == 403) {
      debugPrint('Error: Khong them duoc rent');
      return false;
    }
    return false;
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

  static Future<bool> createNotification(String senderId, String title,
      int type, String receiverId,String dataId) async {
    final response = await http.post(Uri.parse('$url/api/notification/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "senderId": title,
          "title": title,
          "type": type,
          "dateSend": DateTime.now().toString(),
          "receiverId": receiverId,
          "readBy": [],
          "isDelete": [],
          "dataId":dataId
        }));

    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 403) {
      debugPrint('Có gì đó sai sai!');
      return false;
    }
    return false;
  }
}