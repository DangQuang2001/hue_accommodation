import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/notification.dart';

class NotificationRepository{
  static Future<List<Notifications>> getListNotification(String hostID) async {
    final response = await http.get(Uri.parse('$url/api/notification/filter/$hostID'));

    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    return listObject.map((e) => Notifications.fromJson(e)).toList();
  }

  static Future deleteNotification(String hostID) async {
    final response = await http.get(Uri.parse('$url/api/notification/delete-notification/$hostID'));
    return response;
  }

  static Future<bool> readNotification(String hostID)async{
    final response = await http.get(Uri.parse('$url/api/notification/read-notification/$hostID'));
    if(response.statusCode==200){
      return true;
    }
    else{
      debugPrint('Có gì đó sai sai!');
      return false;
    }
  }
}