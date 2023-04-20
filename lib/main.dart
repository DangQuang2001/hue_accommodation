import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hue_accommodation/config/routes/routes.dart';
import 'package:hue_accommodation/config/themes/dark_theme.dart';
import 'package:hue_accommodation/config/themes/light_theme.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/view_models/appLifeCycle.dart';
import 'package:hue_accommodation/view_models/chat_provider.dart';
import 'package:hue_accommodation/view_models/check_and_update_fcmToken.dart';
import 'package:hue_accommodation/view_models/check_login_user.dart';
import 'package:hue_accommodation/view_models/comment_provider.dart';
import 'package:hue_accommodation/view_models/favourite_provider.dart';
import 'package:hue_accommodation/view_models/fcmToken_provider.dart';
import 'package:hue_accommodation/view_models/language_provider.dart';
import 'package:hue_accommodation/view_models/notification_provider.dart';
import 'package:hue_accommodation/view_models/post_provider.dart';
import 'package:hue_accommodation/view_models/rent_provider.dart';
import 'package:hue_accommodation/view_models/room_provider.dart';
import 'package:hue_accommodation/view_models/theme_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'notification/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationController.initializeLocalNotifications(debug: true);
  await NotificationController.initializeRemoteNotifications(debug: true);

  runApp(const MyApp());
}


const MethodChannel platform =  MethodChannel('my_channel');

Future<void> moveToBackground() async {
  try {
    await platform.invokeMethod('moveToBackground');
  } on PlatformException catch (e) {
    print("Failed to move app to background: '${e.message}'.");
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String initialRoute = RouteName.home;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => RoomProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => RentProvider()),
        ChangeNotifierProvider(create: (context) => FcmTokenProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => CommentProvider()),
        ChangeNotifierProvider(create: (context) => FavouriteProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(
            create: (context) => AppLifecycleStateNotifier()),
      ],
      child: Consumer6<
          FcmTokenProvider,
          UserProvider,
          AppLifecycleStateNotifier,
          ThemeProvider,
          NotificationProvider,
          ChatProvider>(
        builder: (context, fcmToken, userProvider, lifecycle, themeObj,
            notificationProvider, chatProvider, child) {
          (() async {
            var connectivityResult = await Connectivity().checkConnectivity();
            if (connectivityResult == ConnectivityResult.mobile ||
                connectivityResult == ConnectivityResult.wifi) {
              checkLoginUser(
                  userProvider, fcmToken, notificationProvider, chatProvider);
              checkAndUpdateFCMToken(
                  lifecycle.lifecycleState, userProvider, fcmToken);
            } else {
              print("Could not connect wifi. Please connect a wifi!");
            }
          })();

          return Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Hue Accommodation',
                routes: routes,
                initialRoute: initialRoute,
                themeMode: themeObj.mode,
                theme: lightTheme,
                darkTheme: darkTheme,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                locale: languageProvider.locale,
                supportedLocales: S.delegate.supportedLocales,
                onGenerateRoute: (RouteSettings settings) {
                  return transitionRightToLeftPage(settings);
                }),
          );
        },
      ),
    );
  }
}
