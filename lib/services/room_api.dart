import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/review.dart';
import '../models/room.dart';

class RoomApi {
  static Future<bool> reviewRoom(String roomId, String userId, double rating,
      String comment, List<String> images) async {
    final response = await http.post(
        Uri.parse('$url/api/motelhouse/review-room'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "roomId": roomId,
          "userId": userId,
          "rating": rating,
          "comment": comment,
          "images": images
        }));
    if (response.statusCode == 200) {
      return true;
    }
    if (response.statusCode == 403) {
      return false;
    }
    return false;
  }

  static Future getReview(String roomId) async {
    final response =
        await http.get(Uri.parse('$url/api/motelhouse/get-review/$roomId'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    if (response.statusCode == 200) {
      return listObject.map((e) => Review.fromJson(e)).toList();
    }
    if (response.statusCode == 403) {
      return [];
    }
    return [];
  }

  static Future<bool> createRoom(
      String hostID,
      String hostName,
      String imageHost,
      String title,
      String description,
      String address,
      Position location,
      double area,
      String category,
      String furnishing,
      double price,
      String typeRoom,
      List<String> listImageUrl) async {
    final response = await http.post(Uri.parse('$url/api/motelhouse/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "dateCreate": DateTime.now().toString(),
          "hostID": hostID,
          "hostName": "Dang Quang",
          "name": title.toString(),
          "description": description,
          "category": typeRoom == 'Mini House'
              ? [1]
              : typeRoom == 'Motel House'
                  ? [2]
                  : [3],
          "images": listImageUrl,
          "longitude": location.longitude,
          "latitude": location.latitude,
          "typeName": category,
          "image": listImageUrl[0],
          "rating": 0,
          "hasRoom": true,
          "idReview": 1,
          "adParams": {
            "address": {"id": "address", "value": address, "label": "Địa chỉ"},
            "area": {"id": "area", "value": "Thành phố Huế", "label": "Quận"},
            "deposit": {
              "id": "deposit",
              "value": "$price",
              "label": "Tiền cọc"
            },
            "furnishing_rent": {
              "id": "furnishing_rent",
              "value": furnishing,
              "label": "Tình trạng nội thất"
            },
            "region": {
              "id": "region",
              "value": "Thừa Thiên Huế",
              "label": "Tỉnh"
            },
            "size": {"id": "size", "value": area, "label": "Diện tích"},
            "ward": {"id": "ward", "value": "", "label": "Phường"}
          },
          "isDelete": false
        }));

    if (response.statusCode == 200) {
      await createNotification(hostID, "đã đăng phòng trọ mới!", 3, "",
          jsonDecode(response.body)['id']);
      final responses =
          await http.get(Uri.parse('$url/api/fcmtoken/get-list-token-device'));
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAlMIgmY8:APA91bHdzbQRIjbCxEvY6JwJqVIVZrnoM-IrjzKxijhbYPUrea9Weg8A4avDg6llt6IYz-nu-yO2iWIcP9jRq1VK0AH01EcE0Vnlrj3E56SR7qvPYmlOlC85PClgCYqqsDDMqLqZcbDY'
          },
          body: jsonEncode(<String, dynamic>{
            "registration_ids":
                (jsonDecode(responses.body) as List<dynamic>).toSet().toList(),
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
                "notificationLayout": "BigPicture",
                "largeIcon": listImageUrl[0],
                "bigPicture": listImageUrl[0],
                "showWhen": true,
                "autoDismissible": true,
                "privacy": "Private",
                "payload": {"secret": "Awesome Notifications Rocks!"}
              },
              "roomID": jsonDecode(response.body)['id'],
              "category": 3,
              "Android": {
                "content": {
                  "title": "$hostName đã mở phòng trọ mới!  😍 ",
                  "payload": {"android": """$title\\n $description """}
                }
              }
            }
          }));
      return true;
    }
    if (response.statusCode == 403) {
      print('Error: Khong them duoc room');
      return false;
    }
    return false;
  }

  static Future<bool> createNotification(String senderId, String title,
      int type, String receiverId, String dataId) async {
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
          "dataId": dataId
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

  static Future<bool> updateRoom(
      String id,
      String hostID,
      String title,
      String description,
      String address,
      Position location,
      double area,
      String category,
      String furnishing,
      double price,
      String typeRoom,
      List<String> listImageUrl) async {
    final response = await http.post(Uri.parse('$url/api/motelhouse/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": id,
          "dateCreate": DateTime.now().toString(),
          "hostID": hostID,
          "hostName": "Dang Quang",
          "name": title.toString(),
          "description": description,
          "category": typeRoom == 'Mini House'
              ? [1]
              : typeRoom == 'Motel House'
                  ? [2]
                  : [3],
          "images": listImageUrl,
          "longitude": location.longitude,
          "latitude": location.latitude,
          "typeName": category,
          "image": listImageUrl[0],
          "rating": 0,
          "hasRoom": true,
          "idReview": 1,
          "adParams": {
            "address": {"id": "address", "value": address, "label": "Địa chỉ"},
            "area": {"id": "area", "value": "Thành phố Huế", "label": "Quận"},
            "deposit": {
              "id": "deposit",
              "value": "$price",
              "label": "Tiền cọc"
            },
            "furnishing_rent": {
              "id": "furnishing_rent",
              "value": furnishing,
              "label": "Tình trạng nội thất"
            },
            "region": {
              "id": "region",
              "value": "Thừa Thiên Huế",
              "label": "Tỉnh"
            },
            "size": {"id": "size", "value": area, "label": "Diện tích"},
            "ward": {"id": "ward", "value": "", "label": "Phường"}
          },
          "isDelete": false
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

  static Future<List<Room>> getAllRoom() async {
    try {
      final response = await http.get(Uri.parse('$url/api/motelhouse'));
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Room.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Có gì đó sai sai: $e');
      return [];
    }
  }

  //Function get list Motel house nearby currentUserPosition with maxDistance & limit
  static Future<List<Room>> getNearby(Position currentUserPosition,
      double maxDistance, int limit, int skip) async {
    try {
      final response = await http.post(
          Uri.parse('$url/api/motelhouse/get-nearby'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            "longitude": currentUserPosition.longitude,
            "latitude": currentUserPosition.latitude,
            "maxDistance": maxDistance,
            "limit": limit,
            "skip": skip
          }));
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => Room.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint('Có gì đó sai sai: $e');
      return [];
    }
  }
}
