import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/notification_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

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
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.countNotification = 0;
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) => Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                S.of(context).notification_title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              userProvider.userCurrent != null
                  ? InkWell(
                      onTap: () {
                        notificationProvider
                            .deleteNotification(userProvider.userCurrent!.id);
                      },
                      child: Text(
                        S.of(context).notification_delete,
                        style: GoogleFonts.readexPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.blue),
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Consumer<NotificationProvider>(
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
                  : Column(
                      children: [
                        ...notificationProvider.listNotification.map((e) =>
                            Container(
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
                                      child: Image.network(
                                        e.imageHost,
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
                                                    text: ("${e.nameHost} đã mở phòng trọ mới.")
                                                        .substring(
                                                            0,
                                                            ("${e.nameHost} đã mở phòng trọ mới.")
                                                                .indexOf(e
                                                                    .nameHost)),
                                                  ),
                                                  TextSpan(
                                                    text: e.nameHost,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                  TextSpan(
                                                    text: ("${e.nameHost} đã mở phòng trọ mới.")
                                                        .substring(
                                                            ("${e.nameHost} đã mở phòng trọ mới.")
                                                                    .indexOf(e
                                                                        .nameHost) +
                                                                e.nameHost
                                                                    .length),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${e.dateSend.split("T")[0]} ${e.dateSend.split("T")[1].split(".")[0]}",
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
                            ))
                      ],
                    ),
        ),
      ),
    );
  }
}
