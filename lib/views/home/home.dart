import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/view_models/room_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house_detail.dart';
import 'package:hue_accommodation/views/login_register/auth_service.dart';
import 'package:hue_accommodation/views/qr_code/qr_code_scanner.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/room.dart';
import '../../view_models/chat_provider.dart';

mixin AppCloser {
  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AppCloser {
  bool users = true;
  bool a = false;
  List<String> imageList = [
    'https://blog.rever.vn/hubfs/cho_thue_phong_tro_moi_xay_gia_re_ngay_phuong_15_tan_binh3.jpg',
    'https://mogi.vn/news/wp-content/uploads/2022/04/phong-tro-gac-lung-dep.jpg',
    'https://blogcdn.muaban.net/wp-content/uploads/2022/12/26172116/thiet-ke-phong-tro-30m2.jpg',
  ];
  @override
  initState() {
    super.initState();
    // Add listeners to this class
    var roomProvider = Provider.of<RoomProvider>(context, listen: false);
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      Room room = await roomProvider.getDetailRoom(message.data['roomID']);
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BoardingHouseDetail(motel: room)));
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      chatProvider.getRoomChat(userProvider.userCurrent!.id);
      final helpSnackBar = SnackBar(
        margin: const EdgeInsets.only(bottom: 1000, top: 50),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Tin nhắn mới!',
          message: 'Dang Quang đã gửi tin nhắn cho bạn!',
          contentType: ContentType.help,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(helpSnackBar);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => WillPopScope(
        onWillPop: () async {
          closeApp();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Theme.of(context).colorScheme.background,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  header(context),
                  body(context),
                  userProvider.userCurrent != null
                      ? utilities(context)
                      : const Text(''),
                  slider(context),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Stack(children: [
        Stack(children: [
          Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              height: 240,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                child: Stack(children: [
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                AssetImage('assets/images/bannerHome5.png'))),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Visibility(
                  //     maintainSize: true,
                  //     maintainAnimation: true,
                  //     maintainState: true,
                  //     visible: true,
                  //     child: Image.network(
                  //       "https://cdn.pixabay.com/animation/2022/10/21/06/39/06-39-15-780_512.gif",
                  //       height: 130,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  // Positioned(
                  //   bottom: -13,
                  //   left: 0,
                  //   child: Visibility(
                  //     maintainSize: true,
                  //     maintainAnimation: true,
                  //     maintainState: true,
                  //     visible: _visible,
                  //     child: Image.network(
                  //       "https://media4.giphy.com/media/17oVc5zm3lpcMDBBzK/giphy.gif?cid=ecf05e47f1j4vw6s8gm917hiyf1bx0ow2xfu7gipem590xwx&rid=giphy.gif&ct=s",
                  //       height: 80,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                ]),
              )),
          Positioned(
              left: 35,
              top: 70,
              child: Stack(children: [
                userProvider.userCurrent == null
                    ? Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 40),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AuthService().handleAuthState()),
                              (route) => false,
                            );
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(left: 35),
                            width: 150,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lock_open_outlined,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Đăng nhập",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                )
                              ],
                            ),
                          ),
                        ))
                    : Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 40),
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 40),
                          height: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userProvider.userCurrent!.name,
                                  style: GoogleFonts.readexPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(S.of(context).home_page_title,
                                  style: GoogleFonts.readexPro(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.7))),
                            ],
                          ),
                        )),
                // Container(
                //         padding: const EdgeInsets.only(left: 40),
                //         height: 45,
                //         alignment: Alignment.centerLeft,
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //
                //           ],
                //         ),
                //       ),
                Positioned(
                  left: 0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: CachedNetworkImage(
                        imageUrl: userProvider.userCurrent == null
                            ? "https://st3.depositphotos.com/13159112/17145/v/600/depositphotos_171453724-stock-illustration-default-avatar-profile-icon-grey.jpg"
                            : userProvider.userCurrent!.image == ""
                                ? "https://st3.depositphotos.com/13159112/17145/v/600/depositphotos_171453724-stock-illustration-default-avatar-profile-icon-grey.jpg"
                                : userProvider.userCurrent!.image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ]))
        ]),
        Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.onBackground,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.withOpacity(0.3)
                                  : Colors.transparent)
                    ]),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRCodeScanner())),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        alignment: Alignment.center,
                        width:
                            (MediaQuery.of(context).size.width / 1.2) / 2 - 15,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.4)))),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "https://product.hstatic.net/200000122283/product/c-e1-bb-9d-vi-e1-bb-87t-nam_2c0683597d2d419fac401f51ccbae779_grande.jpg",
                              width: 40,
                              height: 25,
                              filterQuality: FilterQuality.low,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("Hue City",
                                style:
                                    Theme.of(context).textTheme.displaySmall),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            Text(
                              S.of(context).home_page_qrcode,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.network(
                              "https://media4.giphy.com/media/KbkbRXkIdbiWknW9Ur/giphy.gif?cid=ecf05e47swmprxsjnsazm9865g9qdvutyqck4tq8h4izkxh8&rid=giphy.gif&ct=g",
                              width: 50,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
      ]),
    );
  }

  Widget body(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 270,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonLink(
                        context,
                        "https://cdn-icons-png.flaticon.com/512/3010/3010995.png",
                        S.of(context).home_page_motel,
                        RouteName.boardinghouse,
                        true,
                        300),
                    buttonLink(
                        context,
                        "https://cdn-icons-png.flaticon.com/512/3820/3820134.png",
                        S.of(context).home_page_forum,
                        RouteName.blogSale,
                        userProvider.userCurrent != null,
                        400),
                  ]),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 243,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buttonLinkSmall(
                                    context,
                                    "https://cdn-icons-png.flaticon.com/512/384/384999.png",
                                    S.of(context).home_page_super_market,
                                    RouteName.superMarket,
                                    300,
                                    false),
                                buttonLinkSmall(
                                    context,
                                    "https://cdn-icons-png.flaticon.com/512/4320/4320350.png",
                                    S.of(context).home_page_hospital,
                                    RouteName.hospital,
                                    400,
                                    false),
                              ],
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buttonLinkSmall(
                                    context,
                                    "https://cdn-icons-png.flaticon.com/512/1261/1261143.png",
                                    S.of(context).home_page_household_goods,
                                    RouteName.householdGoods,
                                    500,
                                    false),
                                buttonLinkSmall(
                                    context,
                                    "https://cdn-icons-png.flaticon.com/512/9747/9747020.png",
                                    'ATM',
                                    RouteName.atm,
                                    500,
                                    false),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      S.of(context).home_page_extension,
                      style: Theme.of(context).textTheme.displayMedium,
                    )
                  ],
                ),
              )
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     buttonLink(
              //         context,
              //         "https://cdn-icons-png.flaticon.com/512/1261/1261143.png",
              //         "Household Goods",
              //         RouteName.home),
              //     buttonLink(
              //         context,
              //         "https://cdn-icons-png.flaticon.com/512/3062/3062634.png",
              //         "Messages",
              //         RouteName.home),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget utilities(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 30, right: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).home_page_manage,
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buttonLinkSmall(
                    context,
                    "https://cdn-icons-png.flaticon.com/512/4757/4757351.png",
                    S.of(context).home_page_room,
                    RouteName.roomManage,
                    300,
                    false),
                buttonLinkSmall(
                    context,
                    "https://cdn-icons-png.flaticon.com/512/9155/9155818.png",
                    S.of(context).home_page_rent,
                    RouteName.interactManage,
                    400,
                    false),
                buttonLinkSmall(
                    context,
                    "https://cdn-icons-png.flaticon.com/512/2783/2783924.png",
                    S.of(context).home_page_statistical,
                    RouteName.statisticalManage,
                    500,
                    false),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buttonLink(BuildContext context, String image, String name,
      String page, bool isNavigator, int duration) {
    return GestureDetector(
      onTap: () {
        if (isNavigator) {
          Navigator.pushNamed(context, page);
        } else {
          final snackBar = SnackBar(
            backgroundColor: Colors.redAccent,
            content: const Text('Bạn phải đăng nhập để sử dụng chức năng này!'),
            action: SnackBarAction(
              label: 'Đăng nhập',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthService().handleAuthState()));
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: SlideInRight(
        duration: Duration(milliseconds: duration),
        child: SizedBox(
          width: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                          color: Colors.grey.withOpacity(0.1))
                    ]),
                child: Center(
                  child: CachedNetworkImage(imageUrl: image),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.displayMedium,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonLinkSmall(BuildContext context, String image, String name,
      String page, int duration, bool isComingSoon) {
    return SlideInRight(
      duration: Duration(milliseconds: duration),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (isComingSoon) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: const Text('Chức năng đang được phát triển!'),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Navigator.pushNamed(context, page);
              }
            },
            child: Hero(
              tag: name,
              child: Container(
                padding: const EdgeInsets.all(15),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: Theme.of(context).brightness == Brightness.light
                        ? [
                            BoxShadow(
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                                color: Colors.grey.withOpacity(0.2))
                          ]
                        : null),
                child: Center(
                  child: CachedNetworkImage(imageUrl: image),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 90,
            child: Center(
              child: Text(name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
        ],
      ),
    );
  }

  Widget slider(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: imageList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 40, left: 25.0, right: 25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageList[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
