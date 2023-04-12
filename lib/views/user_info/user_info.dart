// ignore_for_file: unrelated_type_equality_checks

import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/chat_provider.dart';
import 'package:hue_accommodation/view_models/fcmToken_provider.dart';
import 'package:hue_accommodation/view_models/notification_provider.dart';
import 'package:hue_accommodation/view_models/theme_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:hue_accommodation/views/user_info/rent_history.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../constants/route_name.dart';
import '../login_register/auth_service.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  List<AssetEntity> _images = [];
  List<String> listImageUrl = [];
  bool _isloading = false;

  Future<void> _selectImages() async {
    List<AssetEntity>? result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.image,
          selectedAssets: [],
        ));
    setState(() {
      _images = result!;
    });
  }

  Future<void> _uploadImages() async {
    final storage = FirebaseStorage.instance;
    for (var asset in _images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('images').child(fileName);
      final File? file = await asset.file;
      if (file != null) {
        UploadTask task = reference.putFile(file);
        await task.whenComplete(() => null);
        String imageUrl = await reference.getDownloadURL();
        listImageUrl.add(imageUrl);

        // rest of the code here
      } else {
        // handle error, e.g. file is null
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), editing(context)],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Profile',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.editProfile);
                    },
                    child: Icon(
                      Icons.edit_note_outlined,
                      color: Theme.of(context).iconTheme.color,
                      size: 30,
                    )),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  CircularBorder(
                    width: 2.5,
                    size: 160,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: CachedNetworkImage(
                        imageUrl: userProvider.userCurrent == null
                            ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                            : userProvider.userCurrent!.image == ""
                                ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                : userProvider.userCurrent!.image,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  userProvider.userCurrent == null
                      ? const Text('')
                      : Positioned(
                          bottom: 5,
                          right: 5,
                          child: InkWell(
                            onTap: () async {
                              await _selectImages();
                              // ignore: use_build_context_synchronously
                              _dialogBuilder(context, _images);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Theme.of(context).colorScheme.primary),
                              child: const Center(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                userProvider.userCurrent == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AuthService().handleAuthState()),
                                (route) => false),
                            child: Container(
                              width: 100,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary),
                              child: Center(
                                  child: Text(
                                'Sign in',
                                style: GoogleFonts.readexPro(
                                    color: Colors.white, fontSize: 16),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, RouteName.register),
                            child: Container(
                              width: 100,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              child: Center(
                                  child: Text(
                                'Register',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              )),
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            userProvider.userCurrent!.name,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            userProvider.userCurrent!.email,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                          ),
                        ],
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget editing(BuildContext context) {
    return Consumer4<FcmTokenProvider,UserProvider,NotificationProvider,ChatProvider>(
      builder: (context, fcmTokenProvider,userProvider,notificationProvider,chatProvider, child) =>  SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: SlideInRight(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      'CONTENT',
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          letterSpacing: 2),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  color: Theme.of(context).colorScheme.onBackground,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        itemNavigator(context, Icons.newspaper_rounded, 'Posts',RouteName.postHistory,200),
                        const SizedBox(
                          height: 20,
                        ),
                        itemNavigator(context, Icons.favorite_border_outlined,
                            'Favourites',RouteName.favorite,300),
                        const SizedBox(
                          height: 20,
                        ),
                        itemNavigator(context, Icons.home_work_outlined,
                            'Rented',RouteName.rentHistory,400),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                  child: SlideInRight(
                    delay: const Duration(milliseconds: 200),
                    duration: Duration(milliseconds: 200),
                    child: Text(
                      'PREFERENCE',
                      style: GoogleFonts.readexPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          letterSpacing: 2),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  color: Theme.of(context).colorScheme.onBackground,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SlideInRight(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.language_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Language',
                                    style: GoogleFonts.readexPro(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black54
                                            : Colors.white),
                                  )
                                ],
                              ),
                              Image.network(
                                'https://cdn-icons-png.flaticon.com/512/5975/5975456.png',
                                width: 40,
                                height: 25,
                                fit: BoxFit.cover,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SlideInRight(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 300),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.dark_mode_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Dark mode',
                                    style: GoogleFonts.readexPro(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w300,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black54
                                            : Colors.white),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                                child: Transform.scale(
                                  scale: 1.3,
                                  child: Consumer<ThemeProvider>(
                                    builder: (context, values, child) => Switch(
                                      // This bool value toggles the switch.

                                      value: !values.light,
                                      activeColor: Colors.blue,
                                      onChanged: (bool value) {
                                        // This is called when the user toggles the switch.
                                        setState(() {
                                          if (values.light) {
                                            values.setDarkMode();
                                          } else {
                                            values.setLightMode();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        userProvider.userCurrent == null
                            ? Container(
                                height: 0,
                              )
                            : InkWell(
                                onTap: () async{
                                  if (!userProvider.userCurrent!.isGoogle) {
                                    final String? currentToken =
                                    await FirebaseMessaging.instance.getToken();
                                    await fcmTokenProvider.checkUserLogOut(userProvider.userCurrent!.id,currentToken!);
                                    userProvider.userCurrent = null;
                                    chatProvider.listRoomChat =[];
                                    notificationProvider.countNotification=0;
                                    notificationProvider.listNotification=[];
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        RouteName.home, (route) => false);
                                  } else {
                                    final String? currentToken =
                                    await FirebaseMessaging.instance.getToken();
                                    await fcmTokenProvider.checkUserLogOut(userProvider.userCurrent!.id,currentToken!);
                                    userProvider.userCurrent = null;
                                    chatProvider.listRoomChat =[];
                                    notificationProvider.countNotification=0;
                                    notificationProvider.listNotification=[];
                                    // ignore: use_build_context_synchronously
                                    AuthService().signOut(context);
                                  }
                                },
                                child: SlideInRight(
                                  delay: const Duration(milliseconds: 200),
                                  duration: const Duration(milliseconds: 400),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout_outlined,
                                        color: Theme.of(context).iconTheme.color,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Log out',
                                        style: GoogleFonts.readexPro(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300,
                                            color: Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Colors.black54
                                                : Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }

  Widget itemNavigator(BuildContext context, IconData icon, String name,String page,int duration) {
    return InkWell(
      onTap: ()=>context.pushTransparentRoute(

        const RentHistory(),
      ),
      child: SlideInRight(
        delay: const Duration(milliseconds: 200),
        duration: Duration(milliseconds: duration),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  name,
                  style: GoogleFonts.readexPro(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black54
                          : Colors.white),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, List<AssetEntity> images) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer<UserProvider>(
          builder: (context, userProvider, child) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Change Avatar',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: Text(
                        'Change',
                        style: GoogleFonts.readexPro(fontSize: 15),
                      ),
                      onPressed: () async {
                        await _selectImages();

                        setState(() {
                          images = _images;
                        });
                      },
                    ),
                  ]),
              content:Container(
                alignment: Alignment.center,
                height: 150,
                child: FutureBuilder<File?>(
                  future: images[0].file,
                  builder:
                      (BuildContext context, AsyncSnapshot<File?> snapshot) {
                    if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: _isloading?const CircularProgressIndicator() :Image.file(
                          snapshot.data!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error loading image');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text('Disable',
                      style: GoogleFonts.readexPro(fontSize: 15)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child:
                      Text('Save', style: GoogleFonts.readexPro(fontSize: 15)),
                  onPressed: () async {
                    setState((){
                      _isloading=true;
                    });
                    await _uploadImages();
                    await userProvider.changeAvatar(
                        userProvider.userCurrent!.email, listImageUrl[0]);
                    setState((){
                      _isloading=false;
                    });

                   if(userProvider.isUpdateAvatar){
                     final snackBar = SnackBar(
                       backgroundColor: Colors.green,
                       content: const Text('Cap nhat avatar thanh cong!'),
                       action: SnackBarAction(
                         label: 'Close',
                         onPressed: () {
                           // Some code to undo the change.
                         },
                       ),
                     );

                     // ignore: use_build_context_synchronously
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     // ignore: use_build_context_synchronously
                     Navigator.pop(context);
                   }else{
                     final snackBar = SnackBar(
                       backgroundColor: Colors.redAccent,
                       content: const Text('Cap nhat avatar that bai!'),
                       action: SnackBarAction(
                         label: 'Close',
                         onPressed: () {
                           // Some code to undo the change.
                         },
                       ),
                     );

                     // ignore: use_build_context_synchronously
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     // ignore: use_build_context_synchronously
                     Navigator.pop(context);
                   }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CircularBorder extends StatelessWidget {
  final Color color;
  final double size;
  final double width;
  final Widget icon;

  const CircularBorder(
      {Key? key,
      this.color = Colors.blue,
      this.size = 70,
      this.width = 7.0,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          icon,
          CustomPaint(
            size: Size(size, size),
            foregroundPainter: MyPainter(completeColor: color, width: width),
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  Color lineColor = Colors.transparent;
  Color completeColor;
  double width;

  MyPainter({required this.completeColor, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint complete = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    var percent = (size.width * 0.001) / 2;

    double arcAngle = 2 * pi * percent;

    for (var i = 0; i < 8; i++) {
      var init = (-pi / 2) * (i / 2);

      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), init,
          arcAngle, false, complete);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// class SwipeablePageRoute<T> extends MaterialPageRoute<T> {
//   SwipeablePageRoute({required WidgetBuilder builder})
//       : super(builder: builder);
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     final bool isInitialRoute = ModalRoute.of(context) == this;
//     final Animation<Offset> customAnimation = Tween<Offset>(
//
//       begin: const Offset(1.0, 0.0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//
//       parent: animation,
//       curve: Curves.easeInOutQuint,
//     ));
//
//     return SlideTransition(
//       position: customAnimation,
//       child: child,
//     );
//   }
// }