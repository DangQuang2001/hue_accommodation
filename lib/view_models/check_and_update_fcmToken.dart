import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hue_accommodation/view_models/fcmToken_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';

void checkAndUpdateFCMToken(AppLifecycleState lifecycleState,
    UserProvider userProvider, FcmTokenProvider fcmToken) async {
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
