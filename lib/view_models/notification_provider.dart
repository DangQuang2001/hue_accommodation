import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/notification_api.dart';

import '../models/notification.dart';

class NotificationProvider extends ChangeNotifier{


  List<Notifications> listNotification=[];
  int countNotification =0;
  Future<void> getListNotification(String hostID) async {
    final data = await NotificationApi.getListNotification(hostID);
    listNotification = data;
    countNotification =listNotification.length;
    notifyListeners();
  }
  Future<void> deleteNotification(String hostID) async {
    final response = await NotificationApi.deleteNotification(hostID);
    if(response.statusCode==200){
      getListNotification(hostID);
    }
  }

 disposeNotification() {
    countNotification = 0;
    listNotification = [];
    notifyListeners();
  }
}