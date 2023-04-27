import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/fcm_token_api.dart';

class FcmTokenProvider extends ChangeNotifier {
  bool isCheckDevice = false;
  bool isCheckUser = false;
  Future<bool> isCheckUserToken(String userID, String fcmToken) async {
    isCheckUser = true;
    final response =await FcmTokenApi.isCheckUserToken(userID, fcmToken);
    if (response.statusCode == 200) {
    }
    if (response.statusCode == 201) {
    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }
    return true;
  }

  Future<bool> isCheckDeviceToken(String fcmToken) async {
    isCheckDevice = true;
    final response = await FcmTokenApi.isCheckDeviceToken(fcmToken);
    if (response.statusCode == 200) {
    }
    if (response.statusCode == 201) {
    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }
    return true;
  }

  Future<bool> checkDeviceTurnOff(String fcmToken, bool isOpenApp) async {
    isCheckDevice = true;
    final response = await FcmTokenApi.checkDeviceTurnOff(fcmToken, isOpenApp);
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }
    return true;
  }

  Future<bool> checkUserTurnOff(
      String userID, String fcmToken, bool isOnline) async {
    final response = await FcmTokenApi.checkUserTurnOff(userID, fcmToken, isOnline);
    if (response.statusCode == 200) {
      isCheckUser = true;
    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }
    return true;
  }

  Future<bool> checkUserLogOut(String userID, String fcmToken) async {
    final response = await FcmTokenApi.checkUserLogOut(userID, fcmToken);
    if (response.statusCode == 200) {
      isCheckUser = false;
      isCheckDevice = false;
    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }
    return true;
  }
}
