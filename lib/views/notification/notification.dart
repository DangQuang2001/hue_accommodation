import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/view_models/notification_view_model.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house_detail.dart';
import 'package:hue_accommodation/views/components/slide_route.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../view_models/room_view_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var notificationProvider =
        Provider.of<NotificationViewModel>(context, listen: false);
    var userProvider =
    Provider.of<UserViewModel>(context, listen: false);
    notificationProvider.countNotification = 0;
    if(userProvider.userCurrent!=null){
      notificationProvider.readNotification(userProvider.userCurrent!.id);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), items(context)],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userProvider, child) => Consumer<NotificationViewModel>(
        builder: (context, notificationProvider, child) => Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SlideInRight(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  S.of(context).notification_title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              userProvider.userCurrent != null
                  ? InkWell(
                      onTap: () {
                        notificationProvider
                            .deleteNotification(userProvider.userCurrent!.id);
                      },
                      child: SlideInRight(
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          S.of(context).notification_delete,
                          style: GoogleFonts.readexPro(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.blue),
                        ),
                      ),
                    )
                  : const Text("")
            ],
          ),
        ),
      ),
    );
  }

  Widget items(BuildContext context) {
    return Expanded(
      child: Consumer2<UserViewModel,RoomViewModel>(
        builder: (context, userProvider,roomProvider, child) => Consumer<NotificationViewModel>(
          builder: (context, notificationProvider, child) => Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
            child: userProvider.userCurrent == null
                ? Text(
                    "Login to seen notification!",
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                : notificationProvider.listNotification.isEmpty
                    ? Text(
                        S.of(context).notification_status,
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    : SingleChildScrollView(
                      child: Column(
                          children: [
                            ...notificationProvider.listNotification.map((e) =>
                                GestureDetector(
                                  onTap: ()async{
                                    if(e.type ==1){
                                      Navigator.pushNamed(context, RouteName.interactManage);
                                    }
                                    if(e.type ==2){
                                      Navigator.pushNamed(context, RouteName.rentHistory);
                                    }
                                    if(e.type==3){
                                      final data= await roomProvider.getDetailRoom(e.dataId);
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).push(slideRightToLeft( BoardingHouseDetail(motel: data)));
                                    }
                                  },
                                  child: SlideInRight(
                                    duration: const Duration(milliseconds: 500),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 20, top: 20),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey.withOpacity(0.3),
                                                  width: 1))),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Stack(children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                e.sender.image,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(25),
                                                      color: Colors.orangeAccent),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.notifications,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ))
                                          ]),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: ("${e.sender.name} ${e.title}")
                                                                .substring(
                                                                    0,
                                                                    ("${e.sender.name} ${e.title}")
                                                                        .indexOf(e.sender.name)),
                                                          ),
                                                          TextSpan(
                                                            text: e.sender.name,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .displayMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          TextSpan(
                                                            text: ("${e.sender.name} ${e.title}")
                                                                .substring(
                                                                    ("${e.sender.name} ${e.title}")
                                                                            .indexOf(e.sender.name) +
                                                                        e.sender.name
                                                                            .length),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      e.dateSend.toString().split(".")[0],
                                                      style: GoogleFonts.readexPro(
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                    ),
          ),
        ),
      ),
    );
  }
}
