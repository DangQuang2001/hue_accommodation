import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hue_accommodation/config/routes/routes.dart';
import 'package:hue_accommodation/config/themes/dark_theme.dart';
import 'package:hue_accommodation/config/themes/light_theme.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/view_models/appLifeCycle.dart';
import 'package:hue_accommodation/view_models/check_and_update_fcmToken.dart';
import 'package:hue_accommodation/view_models/check_login_user.dart';
import 'package:hue_accommodation/view_models/language_view_model.dart';
import 'package:hue_accommodation/view_models/room_view_model.dart';
import 'package:hue_accommodation/view_models/theme_view_model.dart';
import 'package:provider/provider.dart';
import 'config/provider/provider_manager.dart';
import 'generated/l10n.dart';
import 'utils/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationController.initializeLocalNotifications(debug: true);
  await NotificationController.initializeRemoteNotifications(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    String initialRoute = RouteName.home;
    return MultiProvider(
      providers: providers,
      child: Consumer3<LanguageViewModel, ThemeViewModel, AppLifecycleStateNotifier>(
          builder: (context, languageProvider, themeObj, lifecycle, child) {
        var roomModel = Provider.of<RoomViewModel>(context, listen: false);

        Connectivity().checkConnectivity().then((connectivityResult) {
          if (connectivityResult == ConnectivityResult.mobile ||
              connectivityResult == ConnectivityResult.wifi) {
            checkLoginUser(context);
            checkAndUpdateFCMToken(context, lifecycle.lifecycleState);
          } else {
            if (roomModel.isConnect == false) {
              roomModel.getListNoInternet();
            }
            debugPrint("Could not connect wifi. Please connect a wifi!");
          }
        });

        return MaterialApp(
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
            });
      }),
    );
  }
}

