import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import '../../view_models/room_view_model.dart';

class RemoveRoomPage extends StatefulWidget {
  const RemoveRoomPage({Key? key}) : super(key: key);

  @override
  State<RemoveRoomPage> createState() => _RemoveRoomPageState();
}

class _RemoveRoomPageState extends State<RemoveRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), listRemove(context)],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, right: 20, left: 20),
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
            tag: "RemoveRoom",
            child: Text(
              '     Recycle Bin      ',
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

  Widget listRemove(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Consumer<UserViewModel>(
        builder: (context, userProvider, child) =>  Consumer<RoomViewModel>(
          builder: (context, value, child) => ListView.builder(
            shrinkWrap: true,
            itemCount: value.listRemove.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
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
                    key: UniqueKey(),

                    // The start action pane is the one at the left or the top side.
                    endActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      // dismissible: DismissiblePane(onDismissed: () {}),

                      // All actions are defined in the children parameter.

                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            (()async{
                              await value.restore(value.listRemove[index].id);
                              await value.getListRemove(userProvider.userCurrent!.id);

                            })();
                          },
                          backgroundColor: const Color(0xFF2170CA),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Restore',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            _dialogBuilder(
                                context, value.listRemove[index].id,userProvider.userCurrent!.id);
                          },
                          backgroundColor: const Color(0xFFFE4A49),
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
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              value.listRemove[index].image,
                              width: 85,
                              height: 85,
                              fit: BoxFit.cover,
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value.listRemove[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                                      value.listRemove[index]
                                          .adParams['deposit'] ==
                                          null
                                          ? "0"
                                          : value.listRemove[index]
                                          .adParams['deposit']['value'],
                                      style: GoogleFonts.readexPro(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17),
                                    ),
                                    const Icon(
                                      Icons.attach_money_outlined,
                                      color: Colors.orangeAccent,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  value.listRemove[index].adParams['address']
                                  ['value'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.readexPro(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
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
          )),
      )
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, String id,String userId) {
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
                    Consumer<RoomViewModel>(
                      builder: (context, value, child) => InkWell(
                        onTap: ()async {
                          await value.deleteRoom(id);
                          await value.getListRemove(userId);
                          setState(() {
                            Navigator.pop(context);
                          });
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
