import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/notification_repository.dart';

import '../models/notification.dart';

class NotificationModel extends ChangeNotifier{


  List<Notifications> listNotification=[];
  int countNotification =0;
  Future<void> getListNotification(String hostID) async {
    final data = await NotificationRepository.getListNotification(hostID);
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
    final response = await NotificationRepository.deleteNotification(hostID);
    if(response.statusCode==200){
      getListNotification(hostID);
    }
  }

  Future readNotification(String hostID)async{
    await NotificationRepository.readNotification(hostID);
  }

 disposeNotification() {
    countNotification = 0;
    listNotification = [];
    notifyListeners();
  }
}