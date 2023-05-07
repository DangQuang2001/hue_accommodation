import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:hue_accommodation/view_models/chat_model.dart';
import 'package:hue_accommodation/view_models/fcmToken_model.dart';
import 'package:hue_accommodation/view_models/notification_model.dart';
import 'package:hue_accommodation/view_models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hue_accommodation/models/user.dart' as user_model;

void checkLoginUser(BuildContext context) async{
  var fcmToken = Provider.of<FcmTokenModel>(context, listen: false);
  var userProvider = Provider.of<UserModel>(context, listen: false);
  var chatProvider = Provider.of<ChatModel>(context, listen: false);
  var notificationProvider =
  Provider.of<NotificationModel>(context, listen: false);
  final String? currentToken = await FirebaseMessaging.instance.getToken();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (FirebaseAuth.instance.currentUser != null &&
      userProvider.userCurrent == null &&
      fcmToken.isCheckUser == false) {
    (() async {
      await userProvider.checkIsmailGoogle(
          FirebaseAuth.instance.currentUser!.email!,
          FirebaseAuth.instance.currentUser!.displayName!,
          FirebaseAuth.instance.currentUser!.photoURL!);
      notificationProvider.getListNotification(userProvider.userCurrent!.id);
      chatProvider.getRoomChat(userProvider.userCurrent!.id);
      fcmToken.isCheckUserToken(
          userProvider.userCurrent!.id, currentToken!);
      fcmToken.checkDeviceTurnOff(currentToken, true);
    })();
  }
  if (userProvider.userCurrent == null &&
      fcmToken.isCheckDevice == false) {
    (() async {
      fcmToken.isCheckDeviceToken(currentToken!);
    })();
  }
  if (userProvider.userCurrent != null &&
      fcmToken.isCheckUser == false) {
    (() async {
      await fcmToken.isCheckUserToken(
          userProvider.userCurrent!.id, currentToken!);
      fcmToken.checkDeviceTurnOff(currentToken, true);
    })();
  }
  if (FirebaseAuth.instance.currentUser == null && userProvider.userCurrent == null ){
    String? userPref = prefs.getString('user');
    if(userPref!=null){
      user_model.User user = user_model.User.fromJson(jsonDecode(userPref));
      userProvider.userCurrent = user;
      notificationProvider.getListNotification(userProvider.userCurrent!.id);
      chatProvider.getRoomChat(userProvider.userCurrent!.id);
      fcmToken.isCheckUserToken(
          userProvider.userCurrent!.id, currentToken!);
      fcmToken.checkDeviceTurnOff(currentToken, true);
    }
  }

}
