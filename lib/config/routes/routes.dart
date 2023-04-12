import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/views/forum/forum.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house.dart';
import 'package:hue_accommodation/views/login_register/login.dart';
import 'package:hue_accommodation/views/login_register/register.dart';
import 'package:hue_accommodation/views/manage/add_room.dart';
import 'package:hue_accommodation/views/manage/interact.dart';
import 'package:hue_accommodation/views/manage/remove_room.dart';
import 'package:hue_accommodation/views/manage/room.dart';
import 'package:hue_accommodation/views/user_info/edit_user.dart';
import 'package:hue_accommodation/views/user_info/favourite.dart';
import 'package:hue_accommodation/views/user_info/post_history.dart';
import 'package:hue_accommodation/views/user_info/rent_history.dart';
import 'package:hue_accommodation/views/user_info/user_info.dart';
import '../../views/components/layout.dart';
import '../../views/manage/statistical.dart';

final routes = {
  RouteName.home: (context) => const Layout(selectedIndex:0),
  RouteName.boardinghouse: (context) =>const  BoardingHousePage(),
  // RouteName.boardinghousedetail: (context) => const BoardingHouseDetail(),
  RouteName.blogSale: (context) =>const ForumPage(),
  RouteName.messages: (context) =>const  Layout(selectedIndex:2),
  RouteName.roomManage:(context)=> const RoomManage(),
  RouteName.interactManage:(context)=> const InteractManage(),
  RouteName.statisticalManage:(context)=> const StatisticalManage(),
  RouteName.addRoom:(context)=> const AddRoomPage(),
  RouteName.removeRoom:(context)=> const RemoveRoomPage(),
  RouteName.login:(context)=> const LoginPage(),
  RouteName.register:(context)=> const RegisterPage(),
  RouteName.editProfile:(context)=> const EditProfile(),
  RouteName.profile:(context)=>  const UserInfoPage(),
  RouteName.rentHistory:(context)=>  const RentHistory(),
  RouteName.favorite:(context)=>  const FavoritePage(),
  RouteName.postHistory:(context)=>  const PostHistory(),


};
