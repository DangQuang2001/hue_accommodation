import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/giphy_view_model.dart';
import 'package:hue_accommodation/view_models/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../view_models/chat_view_model.dart';
import '../../view_models/message_view_model.dart';

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

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  final ChatController _chatController = ChatController();
  late List<Map<String, dynamic>> _messages = [];
  bool isLoading = true;
  late bool isNewRooms;
  bool chooseGif = false;
  bool chooseImage = false;
  List<AssetEntity> albums = [];
  bool isDataProcessed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 11, vsync: this);
    isNewRooms = widget.isNewRoom;
    var userProvider = Provider.of<UserViewModel>(context, listen: false);
    var chatProvider = Provider.of<ChatViewModel>(context, listen: false);
    (() async {
      if (userProvider.userCurrent!.id != widget.infoUserRoom[0]['_id']) {
        await chatProvider.isOnline(widget.infoUserRoom[0]['_id']);
      } else {
        await chatProvider.isOnline(widget.infoUserRoom[1]['_id']);
      }
      _chatController.initSocket(
          widget.roomId,
          [widget.infoUserRoom[0]['_id'], widget.infoUserRoom[1]['_id']],
          userProvider.userCurrent!.id,
          userProvider.userCurrent!);
      if (widget.isNewRoom) {
        _messages = [];
        setState(() {
          isLoading = false;
        });
      } else {
        (() async {
          _messages = await chatProvider.getChatDetail(widget.roomId, -10, 20);
          chatProvider.isReadMessage(
              widget.roomId, userProvider.userCurrent!.id);
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
      body: Consumer3<UserViewModel, GiphyViewModel, ChatViewModel>(
        builder: (context, userProvider, giphyProvider, chatProvider, child) =>
            GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              appBar(context),
              messages(context),
              chooseImage
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FutureBuilder(
                            future: albums[0].file,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Opacity(
                                  opacity: 0.6,
                                  child: Image.file(
                                    snapshot.data!,
                                    width: 250,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return const Text('');
                              }
                            }),
                      ],
                    )
                  : const Text(''),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                          });
                        },
                        controller: _textController,
                        decoration: InputDecoration(
                          prefix: albums.isEmpty && chooseImage == false
                              ? const Text('')
                              : FutureBuilder(
                                  future: albums[0].file,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Stack(children: [
                                        GestureDetector(
                                          onTap: () async {
                                            albums =
                                                (await AssetPicker.pickAssets(
                                                    context,
                                                    pickerConfig:
                                                        const AssetPickerConfig(
                                                            maxAssets: 1,
                                                            requestType:
                                                                RequestType
                                                                    .image)))!;
                                          },
                                          child: Image.file(
                                            snapshot.data!,
                                            width: 250,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                            right: -10,
                                            top: 0,
                                            child: TextButton(
                                                onPressed: () {
                                                  _textController.clear();
                                                  setState(() {
                                                    albums = [];
                                                  });
                                                },
                                                child: const Text(
                                                  'X',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )))
                                      ]);
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                          hintText: albums.isEmpty ? 'Enter a message' : "",
                        ),
                      ),
                    ),
                    _textController.text.isEmpty || _textController.text == ""
                        ? Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.emoji_emotions_outlined),
                                onPressed: () {
                                  giphyProvider.getCategories();
                                  giphyProvider.getTrending();
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WillPopScope(
                                        onWillPop: () async {
                                          chooseGif = false;
                                          _textController.clear();
                                          return true;
                                        },
                                        child: Consumer<GiphyViewModel>(
                                          builder:
                                              (context, giphyProvider, child) =>
                                                  SizedBox(
                                            height: 400.0,
                                            child: StatefulBuilder(
                                              builder: (context, setState) =>
                                                  Column(
                                                children: [
                                                  SizedBox(
                                                    height: 50,
                                                    child: giphyProvider
                                                            .listCategories
                                                            .isEmpty
                                                        ? const Text('')
                                                        : TabBar(
                                                            onTap: (value) {
                                                              final selectedTab = _tabController
                                                                          .index ==
                                                                      0
                                                                  ? 'trending'
                                                                  : giphyProvider
                                                                          .listCategories[
                                                                      value -
                                                                          1]['name'];
                                                              giphyProvider
                                                                  .getGiphyByCategory(
                                                                      selectedTab);
                                                            },
                                                            controller:
                                                                _tabController,
                                                            isScrollable: true,
                                                            labelColor:
                                                                Colors.grey,
                                                            labelStyle: Theme
                                                                    .of(context)
                                                                .textTheme
                                                                .displayMedium,
                                                            tabs: [
                                                                const Tab(
                                                                  text:
                                                                      'trending',
                                                                ),
                                                                ...giphyProvider
                                                                    .listCategories
                                                                    .map(
                                                                        (e) =>
                                                                            Tab(
                                                                              text: e['name'],
                                                                            ))
                                                              ]),
                                                  ),
                                                  Expanded(
                                                    child:
                                                        giphyProvider
                                                                .listTrending
                                                                .isEmpty
                                                            ? const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )
                                                            : Stack(children: [
                                                                GridView
                                                                    .builder(
                                                                  gridDelegate:
                                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        2,
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(5),
                                                                  itemCount:
                                                                      giphyProvider
                                                                          .listTrending
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          int index) {
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              2.0),
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          if (_textController.text !=
                                                                              giphyProvider.listTrending[index]['images']['fixed_height_small']['url']) {
                                                                            _textController.text =
                                                                                giphyProvider.listTrending[index]['images']['fixed_height_small']['url'];
                                                                            setState(() {
                                                                              chooseGif = true;
                                                                            });
                                                                          } else {
                                                                            _textController.clear();
                                                                            setState(() {
                                                                              chooseGif = false;
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            Opacity(
                                                                          opacity: _textController.text == giphyProvider.listTrending[index]['images']['fixed_height_small']['url']
                                                                              ? 0.4
                                                                              : 1,
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                giphyProvider.listTrending[index]['images']['fixed_height_small']['url'],
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                chooseGif
                                                                    ? Positioned(
                                                                        bottom:
                                                                            20,
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              50,
                                                                          child: ElevatedButton(
                                                                              onPressed: () {
                                                                                _chatController.sendMessage(
                                                                                    userProvider
                                                                                        .userCurrent!.id,
                                                                                    [
                                                                                      widget.infoUserRoom[0]['_id'],
                                                                                      widget.infoUserRoom[1]['_id']
                                                                                    ],
                                                                                    _textController.text,
                                                                                    'gif',
                                                                                    false);
                                                                                _textController.clear();
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Text('Send')),
                                                                        ),
                                                                      )
                                                                    : const Text(
                                                                        '')
                                                              ]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                  onPressed: () async {
                                    albums = (await AssetPicker.pickAssets(
                                        context,
                                        pickerConfig: const AssetPickerConfig(
                                            maxAssets: 1,
                                            requestType: RequestType.image)))!;
                                    setState(() {
                                      _textController.text = '  ';
                                    });
                                  },
                                  icon: const Icon(Icons.image_outlined))
                            ],
                          )
                        : IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () async {
                              setState(() {
                                chooseImage = true;
                                isDataProcessed = false;
                              });
                              if (albums.isNotEmpty) {
                                _textController.text =
                                    await chatProvider.uploadImages(albums);
                              }

                              if (isNewRooms) {
                                _chatController.sendMessage(
                                    userProvider.userCurrent!.id,
                                    [
                                      widget.infoUserRoom[0]['_id'],
                                      widget.infoUserRoom[1]['_id']
                                    ],
                                    _textController.text,
                                    albums.isEmpty ? 'text' : 'image',
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
                                    albums.isEmpty ? 'text' : 'image',
                                    false);
                                _textController.clear();
                              }
                              setState(() {
                                chooseImage = false;
                                albums = [];
                              });
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
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
    return Consumer<UserViewModel>(
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
    return Consumer2<UserViewModel, ChatViewModel>(
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
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      Map<String, dynamic> messages = {...snapshot.data!};

                       if (_messages.isEmpty || _messages[0] != messages) {
                        _messages.insert(_messages.length, messages);
                        print(messages['content']);
                        snapshot.data!.clear();
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
                            message['typeM'] == 'gif'
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: message['content'],
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          "${DateTime.parse(message['createdAt']).hour.toString().padLeft(2, '0')}:${DateTime.parse(message['createdAt']).minute.toString().padLeft(2, '0')}",
                                          style: GoogleFonts.readexPro(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  )
                                : message['typeM'] == 'image'
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: message['content'],
                                              width: 200,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "${DateTime.parse(message['createdAt']).hour.toString().padLeft(2, '0')}:${DateTime.parse(message['createdAt']).minute.toString().padLeft(2, '0')}",
                                              style: GoogleFonts.readexPro(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 7, horizontal: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isMyMessage
                                              ? Colors.blue.withOpacity(0.7)
                                              : Colors.grey[500],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    2 /
                                                    3),
                                            child: Wrap(
                                              alignment: WrapAlignment.end,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.end,
                                              children: [
                                                Text(
                                                  message['content'],
                                                  style: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 17,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "${DateTime.parse(message['createdAt']).hour.toString().padLeft(2, '0')}:${DateTime.parse(message['createdAt']).minute.toString().padLeft(2, '0')}",
                                                      style:
                                                          GoogleFonts.readexPro(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const Icon(Icons.check,
                                                        color:
                                                            Colors.greenAccent,
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
