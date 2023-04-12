import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/models/room.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:hue_accommodation/views/manage/edit_room.dart';
import 'package:provider/provider.dart';

import '../../view_models/room_provider.dart';

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

    Provider.of<RoomProvider>(context, listen: false).getListRemove(
        Provider.of<UserProvider>(context, listen: false).userCurrent!.id);
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
          InkWell(
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
          Hero(
            tag: "Room",
            child: Text(
              '     Room Management    ',
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
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Container(
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
                  'Join date:',
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
                  'Address:',
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
                  'Feedback chat:',
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
                Text(
                  'Posted',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, RouteName.addRoom),
                      child: Hero(
                        tag: 'AddRoom',
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
                          Consumer<RoomProvider>(
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
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Consumer<UserProvider>(
              builder: (context, userProvider, child) => Consumer<RoomProvider>(
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
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
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
                                        children: [
                                          // A SlidableAction can have an icon and/or a label.

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
                                            label: 'Update',
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
                                            label: 'Delete',
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
                                                imageUrl:
                                                    snapshot.data![index].image,
                                                width: 85,
                                                height: 85,
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
                                                    snapshot.data![index].name,
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
                                                        color:
                                                            Colors.orangeAccent,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    snapshot.data![index]
                                                            .adParams['address']
                                                        ['value'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.readexPro(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
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
                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) =>
                          Consumer<RoomProvider>(
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
}