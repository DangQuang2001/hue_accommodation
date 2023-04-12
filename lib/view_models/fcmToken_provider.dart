import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

class FcmTokenProvider extends ChangeNotifier{
  bool isCheckDevice = false;
  bool isCheckUser = false;
  Future<bool> isCheckUserToken(String userID,String fcmToken) async {
    final response = await http.post(Uri.parse('$url/api/fcmtoken/check-user-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "userID":userID,
          "fcmToken": fcmToken,
          "isOnline":true,
          "isSignOut":false,
          "lastSigned":DateTime.now().toString()
        }));
    if (response.statusCode == 200) {
      isCheckUser = true;

    }
    if (response.statusCode == 201) {
      isCheckUser = true;

    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }

    return true;
  }

  Future<bool> isCheckDeviceToken(String fcmToken) async {
    final response = await http.post(Uri.parse('$url/api/fcmtoken/checkdevicetoken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "fcmToken": fcmToken,
          "isOpenApp":true,
          "lastSigned":DateTime.now().toString()
        }));
    if (response.statusCode == 200) {
      isCheckDevice = true;

    }
    if (response.statusCode == 201) {
      isCheckDevice = true;

    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }

    return true;
  }

  Future<bool> checkDeviceTurnOff(String fcmToken,bool isOpenApp) async {
    final response = await http.post(Uri.parse('$url/api/fcmtoken/checkdeviceturnoff'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "fcmToken": fcmToken,
          "isOpenApp":isOpenApp,
          "lastSigned":DateTime.now().toString()
        }));
    if (response.statusCode == 200) {
      isCheckDevice = true;

    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }

    return true;
  }
  Future<bool> checkUserTurnOff(String userID,String fcmToken,bool isOnline) async {
    final response = await http.post(Uri.parse('$url/api/fcmtoken/check-user-turn-off'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "userID":userID,
          "fcmToken": fcmToken,
          "isOnline":isOnline,
          "isSignOut":false,
          "lastSigned":DateTime.now().toString()
        }));
    if (response.statusCode == 200) {
      isCheckUser = true;

    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }

    return true;
  }
  Future<bool> checkUserLogOut(String userID,String fcmToken) async {
    final response = await http.post(Uri.parse('$url/api/fcmtoken/check-user-logout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "userID":userID,
          "fcmToken": fcmToken,
          "isOnline":false,
          "isSignOut":true,
          "lastSigned":DateTime.now().toString()
        }));
    if (response.statusCode == 200) {
     isCheckUser=false;
     isCheckDevice=false;

    }
    if (response.statusCode == 403) {
      print('Error: Co gi do sai sai');
    }

    return true;
  }
}