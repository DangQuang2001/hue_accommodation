import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/models/room.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house_detail.dart';
import 'package:hue_accommodation/views/components/slide_route.dart';
import 'package:hue_accommodation/views/manage/edit_room.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../view_models/room_view_model.dart';

class RoomManage extends StatefulWidget {
  const RoomManage({Key? key}) : super(key: key);

  @override
  State<RoomManage> createState() => _RoomManageState();
}

class _RoomManageState extends State<RoomManage> {
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    Provider.of<RoomViewModel>(context, listen: false).getListRemove(
        Provider.of<UserViewModel>(context, listen: false).userCurrent!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), info(context), content(context)],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SlideInRight(
            duration:  const Duration(milliseconds: 300),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          SlideInRight(
            duration:  const Duration(milliseconds: 400),
            child: Text(
              '     ${S.of(context).manage_room_title} ',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget info(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userProvider, child) => SlideInRight(
        duration:  const Duration(milliseconds: 300),
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.withOpacity(0.1)
                        : Colors.transparent,
                    blurRadius: 7,
                    offset: const Offset(2, 3))
              ]),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: userProvider.userCurrent!.image == ""
                          ? "https://www.seekpng.com/png/detail/966-9665317_placeholder-image-person-jpg.png"
                          : userProvider.userCurrent!.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userProvider.userCurrent!.name,
                          style: Theme.of(context).textTheme.displayLarge),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '0 follower',
                        style: GoogleFonts.readexPro(
                            color: Colors.grey, fontWeight: FontWeight.w300),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Icon(
                    Icons.date_range_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    S.of(context).manage_room_join_date,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    '17/03/2023',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    S.of(context).manage_room_address,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      userProvider.userCurrent!.address,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.readexPro(
                          fontSize: 17, fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    S.of(context).manage_room_feedback,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    '30',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SlideInRight(
                  duration:  const Duration(milliseconds: 300),
                  child: Text(
                    S.of(context).manage_room_posted,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                SlideInRight(
                  duration:  const Duration(milliseconds: 400),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, RouteName.addRoom),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.withOpacity(0.1)
                                        : Colors.transparent,
                                    blurRadius: 7,
                                    offset: const Offset(2, 2))
                              ]),
                          child: Center(
                            child: Icon(
                              Icons.add_home_outlined,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, RouteName.removeRoom),
                        child: Hero(
                          tag: 'RemoveRoom',
                          child: Stack(children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onBackground,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.grey.withOpacity(0.1)
                                            : Colors.transparent,
                                        blurRadius: 7,
                                        offset: const Offset(2, 2))
                                  ]),
                              child: Center(
                                child: Icon(
                                  Icons.delete_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ),
                            Consumer<RoomViewModel>(
                              builder: (context, value, child) => Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: value.listRemoveLength == 0
                                            ? Colors.transparent
                                            : Colors.redAccent),
                                    child: Center(
                                      child: Text(
                                        value.listRemoveLength == 0
                                            ? ""
                                            : value.listRemoveLength.toString(),
                                        style: GoogleFonts.readexPro(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )),
                            )
                          ]),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Consumer<UserViewModel>(
              builder: (context, userProvider, child) => Consumer<RoomViewModel>(
                builder: (context, value, child) => FutureBuilder<List<Room>>(
                  future: value.getListRoomHost(userProvider.userCurrent!.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.isEmpty
                          ? Text(
                              'No room!',
                              style: Theme.of(context).textTheme.displayMedium,
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                      slideRightToLeft(BoardingHouseDetail(
                                          motel: snapshot.data![index]))),
                                  child: SlideInRight(
                                    duration:   Duration(milliseconds: 100*(index+2)),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      width: MediaQuery.of(context).size.width,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    Colors.grey.withOpacity(0.1),
                                                blurRadius: 7,
                                                offset: const Offset(0, 2))
                                          ]),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Slidable(
                                          key: const ValueKey(0),

                                          // The start action pane is the one at the left or the top side.
                                          endActionPane: ActionPane(
                                            // A motion is a widget used to control how the pane animates.
                                            motion: const ScrollMotion(),

                                            // A pane can dismiss the Slidable.
                                            // dismissible: DismissiblePane(onDismissed: () {}),

                                            // All actions are defined in the children parameter.
                                            children:snapshot.data![index].isConfirmed==2?[

                                              SlidableAction(
                                              onPressed: (context) {
                                                _showNote(context,snapshot.data![index].note!);
                                              },
                                              backgroundColor:
                                                  const Color(0xFF2170CA),
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                              label:'Note',
                                            ),
                                            SlidableAction(
                                              onPressed: (context) {
                                                _dialogBuilder(context,
                                                    snapshot.data![index].id);
                                              },
                                              backgroundColor:
                                                  const Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Remove',
                                            ),
                                            ]: [
                                              // A SlidableAction can have an icon and/or a label.

                                            SlidableAction(
                                              onPressed: (context) {
                                                _showQRcodeImage(context,
                                                    snapshot.data![index].id);
                                              },
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              foregroundColor: Colors.white,
                                              icon: Icons.qr_code,
                                            ),
                                            SlidableAction(
                                              onPressed: (context) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditRoomPage(
                                                                room: snapshot
                                                                        .data![
                                                                    index])));
                                              },
                                              backgroundColor:
                                                  const Color(0xFF2170CA),
                                              foregroundColor: Colors.white,
                                              icon: Icons.edit,
                                            ),
                                            SlidableAction(
                                              onPressed: (context) {
                                                _dialogBuilder(context,
                                                    snapshot.data![index].id);
                                              },
                                              backgroundColor:
                                                  const Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: CachedNetworkImage(
                                                  imageUrl: snapshot
                                                      .data![index].image,
                                                  width: 110,
                                                  height: 110,
                                                  fit: BoxFit.cover,
                                                )),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data![index].name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          snapshot.data![index]
                                                                          .adParams[
                                                                      'deposit'] ==
                                                                  null
                                                              ? "0"
                                                              : snapshot
                                                                      .data![index]
                                                                      .adParams[
                                                                  'deposit']['value'],
                                                          style: GoogleFonts
                                                              .readexPro(
                                                                  color: Colors
                                                                      .orangeAccent,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 17),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .attach_money_outlined,
                                                          color: Colors
                                                              .orangeAccent,
                                                          size: 20,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data![index]
                                                              .adParams[
                                                          'address']['value'],
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.readexPro(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      snapshot.data![index]
                                                              .isConfirmed==0?"Waiting":snapshot.data![index]
                                                              .isConfirmed==1?"Confirmed":"UnConfirmed",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.readexPro(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  snapshot.data![index]
                                                              .isConfirmed==0?Colors.blueAccent:snapshot.data![index]
                                                              .isConfirmed==1?Colors.green:Colors.redAccent),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                            ],
                                          ),
                                         
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return Container(
                        alignment: Alignment.center,
                        child: const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()));
                  },
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            "DELETE",
            style: GoogleFonts.readexPro(),
          )),
          content: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Text("Do you want to delete this?",
                        style: GoogleFonts.readexPro())),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Center(
                            child: Text(
                          'Cancel',
                          style: GoogleFonts.readexPro(color: Colors.white),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Consumer<UserViewModel>(
                      builder: (context, userProvider, child) =>
                          Consumer<RoomViewModel>(
                        builder: (context, value, child) => InkWell(
                          onTap: () {
                            (() async {
                              await value.remove(id);
                              await value
                                  .getListRemove(userProvider.userCurrent!.id);
                              setState(() {
                                Navigator.pop(context);
                              });
                            })();
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent,
                            ),
                            child: Center(
                                child: Text(
                              'Delete',
                              style: GoogleFonts.readexPro(color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showQRcodeImage(BuildContext context, String roomId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(
                child: Text(
              "QRcode",
              style: GoogleFonts.readexPro(),
            )),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: QrImage(
                data: roomId,
                version: QrVersions.auto,
                size: 200.0,
                gapless: false,
              ),
            ));
      },
    );
  }

  Future<void> _showNote(BuildContext context, String note) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(
                child: Text(
              "Note",
              style: GoogleFonts.readexPro(),
            )),
            content: Text(note));
      },
    );
  }
}
