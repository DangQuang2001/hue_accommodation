import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/user_provider.dart';
import 'package:provider/provider.dart';

import '../../view_models/chat_provider.dart';
import '../../view_models/message_provider.dart';

class ChatScreen extends StatefulWidget {
  final bool isNewRoom;
  final String roomId;
  final List infoUserRoom;

  const ChatScreen(
      {super.key,
      required this.isNewRoom,
      required this.roomId,
      required this.infoUserRoom});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ChatController _chatController = ChatController();
  late List<Map<String, dynamic>> _messages = [];
  bool isLoading = true;
  late bool isNewRooms;

  @override
  void initState() {
    super.initState();
    isNewRooms = widget.isNewRoom;
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var chatProvider = Provider.of<ChatProvider>(context, listen: false);
    (()async{
      if(userProvider.userCurrent!.id != widget.infoUserRoom[0]['_id']){
        await chatProvider.isOnline(widget.infoUserRoom[0]['_id']);
      }
      else{
        await chatProvider.isOnline(widget.infoUserRoom[1]['_id']);
      }
      _chatController.initSocket(widget.roomId,
          [widget.infoUserRoom[0]['_id'], widget.infoUserRoom[1]['_id']],userProvider.userCurrent!.id, chatProvider.tokenUser,userProvider.userCurrent!);
      if (widget.isNewRoom) {
        _messages = [];
        setState(() {
          isLoading = false;
        });
      } else {
        (() async {
          _messages = await chatProvider.getChatDetail(widget.roomId, -10, 20);
          chatProvider.isReadMessage(widget.roomId,userProvider.userCurrent!.id );
          setState(() {
            isLoading = false;
          });
        })();
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) => Column(
          children: [
            appBar(context),
            messages(context),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: FocusNode(),
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (isNewRooms) {
                        _chatController.sendMessage(
                            userProvider.userCurrent!.id,
                            [
                              widget.infoUserRoom[0]['_id'],
                              widget.infoUserRoom[1]['_id']
                            ],
                            _textController.text,
                            'text',
                            true);
                        _textController.clear();
                        isNewRooms = false;
                      } else {
                        _chatController.sendMessage(
                            userProvider.userCurrent!.id,
                            [
                              widget.infoUserRoom[0]['_id'],
                              widget.infoUserRoom[1]['_id']
                            ],
                            _textController.text,
                            'text',
                            false);
                        _textController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Widget appBar(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        color: Theme.of(context).colorScheme.onBackground,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      )),
                  const SizedBox(
                    width: 15,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: widget.infoUserRoom[0]['_id'] !=
                              userProvider.userCurrent!.id
                          ? widget.infoUserRoom[0]['image']
                          : widget.infoUserRoom[1]['image'],
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.infoUserRoom[0]['_id'] !=
                            userProvider.userCurrent!.id
                        ? widget.infoUserRoom[0]['name']
                        : widget.infoUserRoom[1]['name'],
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Icon(
                Icons.more_horiz_outlined,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messages(BuildContext context) {
    return Consumer2<UserProvider, ChatProvider>(
      builder: (context, userProvider, chatProvider, child) => Expanded(
        child: isLoading
            ? Container()
            : StreamBuilder(
                stream: _chatController.messages,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData && _messages.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Write something to ${widget.infoUserRoom[0]['name']}!',
                        style: GoogleFonts.readexPro(color: Colors.grey),
                      ),
                    );
                  } else {
                    if (snapshot.hasData) {
                      Map<String, dynamic> messages = snapshot.data!;

                      if (_messages.isEmpty || _messages[0] != messages) {
                        _messages.insert(_messages.length, messages);
                      }
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[_messages.length - 1 - index];
                        final isMyMessage =
                            message['userId'] == userProvider.userCurrent!.id;
                        return Row(
                          mainAxisAlignment: isMyMessage
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMyMessage
                                    ? Colors.blue.withOpacity(0.7)
                                    : Colors.grey[500],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              2 /
                                              3),
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [
                                      Text(
                                        message['content'],
                                        style: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 17,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${DateTime.parse(message['createdAt']).hour.toString().padLeft(2, '0')}:${DateTime.parse(message['createdAt']).minute.toString().padLeft(2, '0')}",
                                            style: GoogleFonts.readexPro(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(Icons.check,
                                              color: Colors.greenAccent,
                                              size: 15)
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
      ),
    );
  }
}
