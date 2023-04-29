import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/notification_api.dart';

import '../models/notification.dart';

class NotificationProvider extends ChangeNotifier{


  List<Notifications> listNotification=[];
  int countNotification =0;
  Future<void> getListNotification(String hostID) async {
    final data = await NotificationApi.getListNotification(hostID);
    listNotification = data;
    if(countNotification == 0){
      for (var element in listNotification) {
        if(!element.readBy.contains(hostID)){
          countNotification = countNotification+1;
        }
      }
    }
    notifyListeners();
  }
  Future<void> deleteNotification(String hostID) async {
    final response = await NotificationApi.deleteNotification(hostID);
    if(response.statusCode==200){
      getListNotification(hostID);
    }
  }

  Future readNotification(String hostID)async{
    await NotificationApi.readNotification(hostID);
  }

 disposeNotification() {
    countNotification = 0;
    listNotification = [];
    notifyListeners();
  }
}