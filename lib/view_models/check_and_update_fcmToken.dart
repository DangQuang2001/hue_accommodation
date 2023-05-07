import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:hue_accommodation/view_models/fcmToken_model.dart';
import 'package:hue_accommodation/view_models/user_model.dart';
import 'package:provider/provider.dart';

void checkAndUpdateFCMToken(BuildContext context,AppLifecycleState lifecycleState) async {
  var fcmToken = Provider.of<FcmTokenModel>(context, listen: false);
  var userProvider = Provider.of<UserModel>(context, listen: false);
  bool check = true;
  final String? currentToken = await FirebaseMessaging.instance.getToken();
  if (currentToken != null) {
    final bool isTurnedOn = lifecycleState == AppLifecycleState.resumed;
    if (userProvider.userCurrent != null &&
        check &&
        fcmToken.isCheckUser == true) {
      final String userId = userProvider.userCurrent!.id;
      fcmToken.checkDeviceTurnOff(currentToken, isTurnedOn);
      fcmToken.checkUserTurnOff(userId, currentToken, isTurnedOn);
      check = false;
    }
    if (check && fcmToken.isCheckDevice == true) {
      fcmToken.checkDeviceTurnOff(currentToken, isTurnedOn);
      check = false;
    }
  }

  if (lifecycleState == AppLifecycleState.detached) {
    print('App is closed');
  } else if (lifecycleState == AppLifecycleState.inactive) {
    check = true;
    print('App is background');
  } else if (lifecycleState == AppLifecycleState.resumed) {
    check = true;
    print('App is foreground');
  }
}
