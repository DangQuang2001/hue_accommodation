import 'package:hue_accommodation/view_models/chat_model.dart';
import 'package:hue_accommodation/view_models/chat_model.dart';
import 'package:hue_accommodation/view_models/comment_model.dart';
import 'package:hue_accommodation/view_models/favourite_model.dart';
import 'package:hue_accommodation/view_models/google_map_model.dart';
import 'package:hue_accommodation/view_models/language_model.dart';
import 'package:hue_accommodation/view_models/notification_model.dart';
import 'package:hue_accommodation/view_models/fcmToken_model.dart';
import 'package:hue_accommodation/view_models/post_model.dart';
import 'package:hue_accommodation/view_models/rent_model.dart';
import 'package:hue_accommodation/view_models/weather_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../view_models/appLifeCycle.dart';
import '../../view_models/giphy_model.dart';
import '../../view_models/room_model.dart';
import '../../view_models/theme_model.dart';
import '../../view_models/user_model.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

/// 独立的model
List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<ThemeModel>(
    create: (context) => ThemeModel(),
  ),
  ChangeNotifierProvider<RoomModel>(
    create: (context) => RoomModel(),
  ),
  ChangeNotifierProvider<UserModel>(
    create: (context) => UserModel(),
  ),
  ChangeNotifierProvider<RentModel>(
    create: (context) => RentModel(),
  ),
  ChangeNotifierProvider<FcmTokenModel>(
    create: (context) => FcmTokenModel(),
  ),
  ChangeNotifierProvider<NotificationModel>(
    create: (context) => NotificationModel(),
  ),
  ChangeNotifierProvider<PostModel>(
    create: (context) => PostModel(),
  ),
  ChangeNotifierProvider<ChatModel>(
    create: (context) => ChatModel(),
  ),
  ChangeNotifierProvider<CommentModel>(
    create: (context) => CommentModel(),
  ),
  ChangeNotifierProvider<FavouriteModel>(
    create: (context) => FavouriteModel(),
  ),
  ChangeNotifierProvider<LanguageModel>(
    create: (context) => LanguageModel(),
  ),
  ChangeNotifierProvider<GoogleMapModel>(
    create: (context) => GoogleMapModel(),
  ),
  ChangeNotifierProvider<WeatherModel>(
    create: (context) => WeatherModel(),
  ),
  ChangeNotifierProvider<GiphyModel>(
    create: (context) => GiphyModel(),
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