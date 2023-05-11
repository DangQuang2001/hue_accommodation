import 'package:hue_accommodation/view_models/chat_view_model.dart';
import 'package:hue_accommodation/view_models/chat_view_model.dart';
import 'package:hue_accommodation/view_models/comment_view_model.dart';
import 'package:hue_accommodation/view_models/favourite_view_model.dart';
import 'package:hue_accommodation/view_models/google_map_view_model.dart';
import 'package:hue_accommodation/view_models/language_view_model.dart';
import 'package:hue_accommodation/view_models/notification_view_model.dart';
import 'package:hue_accommodation/view_models/fcmToken_view_model.dart';
import 'package:hue_accommodation/view_models/post_view_model.dart';
import 'package:hue_accommodation/view_models/rent_view_model.dart';
import 'package:hue_accommodation/view_models/weather_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../view_models/appLifeCycle.dart';
import '../../view_models/giphy_view_model.dart';
import '../../view_models/room_view_model.dart';
import '../../view_models/theme_view_model.dart';
import '../../view_models/user_view_model.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

/// 独立的model
List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<ThemeViewModel>(
    create: (context) => ThemeViewModel(),
  ),
  ChangeNotifierProvider<RoomViewModel>(
    create: (context) => RoomViewModel(),
  ),
  ChangeNotifierProvider<UserViewModel>(
    create: (context) => UserViewModel(),
  ),
  ChangeNotifierProvider<RentViewModel>(
    create: (context) => RentViewModel(),
  ),
  ChangeNotifierProvider<FcmTokenViewModel>(
    create: (context) => FcmTokenViewModel(),
  ),
  ChangeNotifierProvider<NotificationViewModel>(
    create: (context) => NotificationViewModel(),
  ),
  ChangeNotifierProvider<PostViewModel>(
    create: (context) => PostViewModel(),
  ),
  ChangeNotifierProvider<ChatViewModel>(
    create: (context) => ChatViewModel(),
  ),
  ChangeNotifierProvider<CommentViewModel>(
    create: (context) => CommentViewModel(),
  ),
  ChangeNotifierProvider<FavouriteViewModel>(
    create: (context) => FavouriteViewModel(),
  ),
  ChangeNotifierProvider<LanguageViewModel>(
    create: (context) => LanguageViewModel(),
  ),
  ChangeNotifierProvider<GoogleMapViewModel>(
    create: (context) => GoogleMapViewModel(),
  ),
  ChangeNotifierProvider<WeatherViewModel>(
    create: (context) => WeatherViewModel(),
  ),
  ChangeNotifierProvider<GiphyViewModel>(
    create: (context) => GiphyViewModel(),
  ),
  ChangeNotifierProvider<AppLifecycleStateNotifier>(
    create: (context) => AppLifecycleStateNotifier(),
  )
];

/// 需要依赖的model
///
/// UserModel依赖globalFavouriteStateModel
List<SingleChildWidget> dependentServices = [
];

List<SingleChildWidget> uiConsumableProviders = [
//  StreamProvider<User>(
//    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
//  )
];