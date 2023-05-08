import 'package:flutter/material.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/utils/payment.dart';
import 'package:hue_accommodation/views/extension/activity.dart';
import 'package:hue_accommodation/views/extension/atm.dart';
import 'package:hue_accommodation/views/extension/household_good.dart';
import 'package:hue_accommodation/views/extension/nearby.dart';
import 'package:hue_accommodation/views/extension/supermarket.dart';
import 'package:hue_accommodation/views/extension/transpot.dart';
import 'package:hue_accommodation/views/forum/forum.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house.dart';
import 'package:hue_accommodation/views/login_register/login.dart';
import 'package:hue_accommodation/views/login_register/register.dart';
import 'package:hue_accommodation/views/manage/add_room.dart';
import 'package:hue_accommodation/views/manage/interact.dart';
import 'package:hue_accommodation/views/manage/remove_room.dart';
import 'package:hue_accommodation/views/manage/room.dart';
import 'package:hue_accommodation/views/qr_code/qr_code_scanner.dart';
import 'package:hue_accommodation/views/user_info/edit_user.dart';
import 'package:hue_accommodation/views/user_info/favourite.dart';
import 'package:hue_accommodation/views/user_info/post_history.dart';
import 'package:hue_accommodation/views/user_info/rent_history.dart';
import 'package:hue_accommodation/views/user_info/user_info.dart';
import '../../views/components/layout.dart';
import '../../views/extension/hospital.dart';
import '../../views/manage/statistical.dart';

final routes = {
  RouteName.home: (context) => const Layout(selectedIndex: 0),
};

transitionRightToLeftPage(RouteSettings settings) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        switch (settings.name) {
          case RouteName.boardinghouse:
            return const BoardingHousePage();
          case RouteName.blogSale:
            return const ForumPage();
          case RouteName.roomManage:
            return const RoomManage();
          case RouteName.interactManage:
            return const InteractManage();
          case RouteName.statisticalManage:
            return const StatisticalManage();
          case RouteName.addRoom:
            return const AddRoomPage();
          case RouteName.removeRoom:
            return const RemoveRoomPage();
          case RouteName.login:
            return const LoginPage();
          case RouteName.register:
            return const RegisterPage();
          case RouteName.editProfile:
            return const EditProfile();
          case RouteName.profile:
            return const UserInfoPage();
          case RouteName.rentHistory:
            return const RentHistory();
          case RouteName.favorite:
            return const FavoritePage();
          case RouteName.postHistory:
            return const PostHistory();
          case RouteName.atm:
            return const ATMPage();
          case RouteName.hospital:
            return const HospitalPage();
          case RouteName.superMarket:
            return const SuperMarketPage();
          case RouteName.householdGoods:
            return const HouseholdGood();
          case RouteName.qrcode:
            return const QRCodeScanner();
          case RouteName.myActivity:
            return const MyActivity();
          case RouteName.transpot:
            return const TranspotPages();
          case RouteName.nearby:
            return const NearByLocation();

          default:
            return const Layout(selectedIndex: 0);
        }
      },
      transitionDuration: const Duration(milliseconds: 600),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      settings: RouteSettings(name: settings.name));
}
