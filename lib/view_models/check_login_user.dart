import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hue_accommodation/view_models/chat_provider.dart';
import 'package:hue_accommodation/view_models/fcmToken_provider.dart';
import 'package:hue_accommodation/view_models/notification_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';

void checkLoginUser(UserProvider userProvider,FcmTokenProvider fcmToken,NotificationProvider notificationProvider,ChatProvider chatProvider){
  if (FirebaseAuth.instance.currentUser != null &&
      userProvider.userCurrent == null &&
      fcmToken.isCheckUser == false) {
    (() async {
      await userProvider
          .checkIsmailGoogle(FirebaseAuth.instance.currentUser!.email!);
      notificationProvider.getListNotification(userProvider.userCurrent!.id);
      chatProvider.getRoomChat(userProvider.userCurrent!.id);
      final String? currentToken =
      await FirebaseMessaging.instance.getToken();
      await fcmToken.isCheckUserToken(
          userProvider.userCurrent!.id, currentToken!);
      fcmToken.checkDeviceTurnOff(currentToken, true);
    })();
  }
  if (FirebaseAuth.instance.currentUser == null &&
      userProvider.userCurrent == null &&
      fcmToken.isCheckDevice == false) {
    (() async {

      final String? currentToken =
      await FirebaseMessaging.instance.getToken();

      fcmToken.isCheckDeviceToken(currentToken!);
    })();
  }




}