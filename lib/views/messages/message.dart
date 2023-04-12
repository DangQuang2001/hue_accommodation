import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hue_accommodation/view_models/chat_provider.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:hue_accommodation/views/messages/message_detail.dart';
import 'package:provider/provider.dart';


class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [appBar(context), search(context), content(context)],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Hero(
            tag: "Messages",
            child: Text(
              'Messages ',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(
              Icons.more_horiz_outlined,
              color: Theme.of(context).iconTheme.color,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget search(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: SizedBox(
        height: 50,
        child: TextField(
          cursorColor: Colors.grey,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search_sharp,
                color: Theme.of(context).iconTheme.color,
              ),
              filled: true,
              fillColor: Theme.of(context).hintColor,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none, //<-- SEE HERE
                borderRadius: BorderRadius.circular(50.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50.0),
              ),
              hintText: 'Search..',
              hintStyle: Theme.of(context).textTheme.headlineSmall),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Consumer2<UserProvider,ChatProvider>(
      builder: (context,userProvider, chatProvider, child) =>  Expanded(
        child: userProvider.userCurrent==null?
        Padding(
          padding: const EdgeInsets.only(top:20.0),
          child: Text('Login to seen chat!',style: Theme.of(context).textTheme.displayMedium,),
        ):chatProvider.listRoomChat.isEmpty?Text('No chat messages!',style: Theme.of(context).textTheme.displayMedium,): ListView(
          children: [
              ...chatProvider.listRoomChat.map((e) => message(context,e))
          ],
        ),
      ),
    );
  }

  Widget message(BuildContext context,Map<String,dynamic> roomChat) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) =>  GestureDetector(
        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>  ChatScreen(isNewRoom: false,roomId: roomChat['id'],infoUserRoom: roomChat['userId'],))),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).hintColor.withOpacity(0.2)))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl:
                          roomChat['userId'][0]['_id']!=userProvider.userCurrent!.id?roomChat['userId'][0]['image']:roomChat['userId'][1]['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.fill,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roomChat['userId'][0]['_id']!=userProvider.userCurrent!.id?roomChat['userId'][0]['name']:roomChat['userId'][1]['name'],
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Text(
                            "Quang dep trai vl....",
                            style: Theme.of(context).textTheme.headlineMedium,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('9:32 AM',style: Theme.of(context).textTheme.headlineMedium,),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.redAccent
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}