import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/fcm_token_repository.dart';

class FcmTokenModel extends ChangeNotifier {
  bool isCheckDevice = false;
  bool isCheckUser = false;
  Future<bool> isCheckUserToken(String userID, String fcmToken) async {
    isCheckUser = true;
    await FcmTokenRepository.isCheckUserToken(userID, fcmToken);
    return true;
  }

  Future<bool> isCheckDeviceToken(String fcmToken) async {
    isCheckDevice = true;
    await FcmTokenRepository.isCheckDeviceToken(fcmToken);
    return true;
  }

  Future<bool> checkDeviceTurnOff(String fcmToken, bool isOpenApp) async {
    isCheckDevice = true;
    await FcmTokenRepository.checkDeviceTurnOff(fcmToken, isOpenApp);
    return true;
  }

  Future<bool> checkUserTurnOff(
      String userID, String fcmToken, bool isOnline) async {
    await FcmTokenRepository.checkUserTurnOff(userID, fcmToken, isOnline);
    return true;
  }

  Future<bool> checkUserLogOut(String userID, String fcmToken) async {
    final response = await FcmTokenRepository.checkUserLogOut(userID, fcmToken);
    if (response.statusCode == 200) {
      isCheckUser = false;
      isCheckDevice = false;
    }
    return true;
  }
}
