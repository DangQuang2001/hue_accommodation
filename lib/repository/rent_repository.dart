import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/rent.dart';
import 'chat_repository.dart';

class RentRepository{
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
          "isPay":false
        }));
    if (response.statusCode == 200) {
      createNotification(userID,"đã đăng ký thuê phòng!", 1, hostID, "");
      Map<String,dynamic> data =await ChatRepository.isOnline(hostID);
      List<String> listOnline = data['online'].cast<String>();
      List<String> listOffline = data['offline'].cast<String>();
      for (var element in listOnline) {
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
              'key=AAAAlMIgmY8:APA91bHdzbQRIjbCxEvY6JwJqVIVZrnoM-IrjzKxijhbYPUrea9Weg8A4avDg6llt6IYz-nu-yO2iWIcP9jRq1VK0AH01EcE0Vnlrj3E56SR7qvPYmlOlC85PClgCYqqsDDMqLqZcbDY'
            },
            body: jsonEncode(<String, dynamic>{
              "to":element,
              "data": {"title":"Thông báo mới!","message": "$name đã đăng ký thuê phòng!", "type": "notification","category":1}
            }));
      }
      if (listOffline.isNotEmpty) {
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization':
              'key=AAAAlMIgmY8:APA91bHdzbQRIjbCxEvY6JwJqVIVZrnoM-IrjzKxijhbYPUrea9Weg8A4avDg6llt6IYz-nu-yO2iWIcP9jRq1VK0AH01EcE0Vnlrj3E56SR7qvPYmlOlC85PClgCYqqsDDMqLqZcbDY'
            },
            body: jsonEncode(<String, dynamic>{
              "registration_ids":listOffline,
              "priority": "high",
              "content_available": true,
              "notification": {
                "badge": 42,
                "title": "Quuang dep trai!",
                "body": "Image"
              },
              "data": {
                "content": {
                  "id": 1,
                  "badge": 42,
                  "channelKey": "alerts",
                  "displayOnForeground": false,
                  "notificationLayout": "Messaging",
                  "showWhen": true,
                  "autoDismissible": true,
                  "privacy": "Private",
                  "largeIcon": image,
                  "payload": {
                    "secret": "Awesome Notifications Rocks!"
                  }
                },
                "roomID": "1680085730187",
                "category":1,
                "Android": {
                  "content": {
                    "id": 1,
                    "badge": 42,
                    "summary": "Thuê trọ",
                    "title": "Bạn có đơn thuê trọ mới!",
                    "body": "$name đã đăng ký thuê phòng trọ",
                    "payload": {
                      "android": "android custom content!"
                    }
                  }
                }
              }
            }));
      }
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
          "senderId": senderId,
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

  static Future<bool> createPayment(String rentId,double totalPrice, double transitionFee,String description) async {
    final response = await http.post(Uri.parse('$url/api/rent/payment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "payment":{
            "countryCode":84,
            "postalCode":	49000,
            "totalPrice":totalPrice,
            "transitionFee":transitionFee,
            "status":"Succeeded",
            "description":description
          },
          "rentId":rentId
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