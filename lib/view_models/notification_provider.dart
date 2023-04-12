import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/notification.dart';

class NotificationProvider extends ChangeNotifier{


  List<Notifications> listNotification=[];
  int countNotification =0;
  Future<void> getListNotification(String hostID) async {
    final response = await http.get(Uri.parse('$url/api/notification/filter/$hostID'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listNotification = listObject.map((e) => Notifications.fromJson(e)).toList();
    notifyListeners();
    countNotification =listNotification.length;
    notifyListeners();
  }
  Future<void> deleteNotification(String hostID) async {
    final response = await http.get(Uri.parse('$url/api/notification/delete-notification/$hostID'));
    if(response.statusCode==200){
      getListNotification(hostID);
    }
  }
}