import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hue_accommodation/view_models/fcmToken_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';

void checkAndUpdateFCMToken(AppLifecycleState lifecycleState, UserProvider userProvider,FcmTokenProvider fcmToken) async {



  final String? currentToken = await FirebaseMessaging.instance.getToken();

  if (currentToken != null) {
    final bool isTurnedOn = lifecycleState == AppLifecycleState.resumed;

    if (userProvider.userCurrent != null && fcmToken.isCheckUser == false) {
      final String userId = userProvider.userCurrent!.id;
      fcmToken.checkDeviceTurnOff(currentToken, isTurnedOn);
      fcmToken.checkUserTurnOff(userId, currentToken, isTurnedOn);
    } else if(fcmToken.isCheckDevice==false) {
      fcmToken.checkDeviceTurnOff(currentToken, isTurnedOn);
    }
  }

  if (lifecycleState == AppLifecycleState.paused) {
    print('App is closed');
  } else if (lifecycleState == AppLifecycleState.inactive) {
    print('App is background');
  } else if (lifecycleState == AppLifecycleState.resumed) {
    print('App is foreground');
  }
}
