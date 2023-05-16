import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/chat_view_model.dart';
import 'package:hue_accommodation/view_models/rent_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/rent.dart';
import '../../view_models/user_view_model.dart';
import '../messages/message_detail.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({Key? key}) : super(key: key);

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var rentViewModel = Provider.of<RentViewModel>(context, listen: false);
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    rentViewModel.getListConfirm(userViewModel.userCurrent!.id, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), categories(context), content(context)],
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
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 300),
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
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 400),
            child: Text(
              '      User Rent   ',
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

  Widget categories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: SlideInRight(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 400),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(left: 5),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(2, 3))
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Motel house',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayMedium,
                      )),
                      const Icon(
                        Icons.arrow_drop_down_outlined,
                        size: 40,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SlideInRight(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 500),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(left: 5),
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(2, 3))
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Payment',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayMedium,
                      )),
                      const Icon(
                        Icons.arrow_drop_down_outlined,
                        size: 40,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Consumer<RentViewModel>(
      builder: (context, rentViewModel, child) =>rentViewModel.listConfirm.isEmpty?const Padding(
        padding: EdgeInsets.only(top:20.0),
        child: Text('No renters!'),
      ): Expanded(
          child: ListView.builder(
        itemCount: rentViewModel.listConfirm.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            editNotification(context, rentViewModel.listConfirm[index]);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: 230,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(2, 2)),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          imageUrl: rentViewModel.listConfirm[index].user.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rentViewModel.listConfirm[index].user.name,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            rentViewModel.listConfirm[index].user.email,
                            style: Theme.of(context).textTheme.displaySmall,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(Icons.date_range_outlined),
                    Text(
                      "Date rent:",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        rentViewModel.listConfirm[index].dateCreate
                            .split(".")[0],
                        style: Theme.of(context).textTheme.displaySmall)
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(Icons.person_outline_outlined),
                    Text(
                      "Number of renters:",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        rentViewModel.listConfirm[index].numberPeople
                            .toString(),
                        style: Theme.of(context).textTheme.displaySmall)
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.house_outlined),
                    Text(
                      "Room name:",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(rentViewModel.listConfirm[index].roomName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displayMedium),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(Icons.payment),
                    Text(
                      "IsPay:",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        rentViewModel.listConfirm[index].isPay
                            ? "Paid"
                            : "UnPay",
                        style: GoogleFonts.readexPro(
                            color: rentViewModel.listConfirm[index].isPay
                                ? Colors.green
                                : Colors.redAccent,
                            fontSize: 17))
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future editNotification(BuildContext context, Rent rent) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ChatViewModel>(
          builder: (context, chatProvider, child) => Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            color: Theme.of(context).colorScheme.onBackground,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://cdn-icons-png.flaticon.com/512/3578/3578796.png",
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Notice of payment',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await chatProvider
                          .checkRoom([rent.user.id, rent.host.id]);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    isNewRoom: chatProvider.isNewRoom,
                                    roomId: chatProvider.isNewRoom
                                        ? ""
                                        : chatProvider.roomId,
                                    infoUserRoom: chatProvider.infoUserRoom,
                                  )));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://cdn-icons-png.flaticon.com/512/3062/3062634.png",
                          ),
                        ),
                        Text(
                          'Message',
                          style: Theme.of(context).textTheme.displayMedium,
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              color: Theme.of(context).colorScheme.onBackground,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text('STT',style: Theme.of(context).textTheme.displayMedium,),
                                            const SizedBox(height: 20,),
                                            ...rent.payment!.map((e) {
                                              var index = rent.payment!.indexOf(e);
                                              return
                                                  Text((index+1).toString(),style: GoogleFonts.readexPro(fontSize: 15,fontWeight: FontWeight.w300))
                                                ;
                                            } )
                                          ],
                                        ),
                                        const SizedBox(width: 20,),
                                        Column(
                                          children: [
                                            Text('Month',style: Theme.of(context).textTheme.displayMedium,),
                                            const SizedBox(height: 20,),
                                            ...rent.payment!.map((e) {
                                              return
                                                Text(e['createdAt'].toString().split("T")[0],style: GoogleFonts.readexPro(fontSize: 15,fontWeight: FontWeight.w300))
                                              ;
                                            } )
                                          ],
                                        ),
                                        const SizedBox(width: 20,),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text('Description',style: Theme.of(context).textTheme.displayMedium,),
                                              const SizedBox(height: 20,),
                                              ...rent.payment!.map((e) {
                                                return
                                                  Text(e['description'],overflow: TextOverflow.ellipsis,style: GoogleFonts.readexPro(fontSize: 15,fontWeight: FontWeight.w300),)
                                                ;
                                              } )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 30,),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              borderRadius: BorderRadius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://cdn-icons-png.flaticon.com/512/4313/4313096.png",
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            'Payment history',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
