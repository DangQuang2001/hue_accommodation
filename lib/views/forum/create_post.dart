import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/post_model.dart';
import 'package:hue_accommodation/view_models/room_model.dart';
import 'package:hue_accommodation/view_models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../generated/l10n.dart';

class CreatePostPage extends StatefulWidget {
  final List<AssetEntity>? images;

  const CreatePostPage({Key? key, this.images}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  List<AssetEntity> imagesChoose = [];
  int tagSelect = 0;
  String _selectedName = S.current.forum_choose_place;
  String _selectRoomId = '';
  late List listNameRoom;
  String captions = "";
  String title = "";
  bool isPost = true;

  @override
  void initState() {
    super.initState();
    imagesChoose = widget.images ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Stack(children: [
            Column(
              children: [
                appBar(context),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      caption(context),
                      imagesChoose.isEmpty ? const SizedBox() : images(context),
                      location(context)
                    ],
                  ),
                ))
              ],
            ),
            isPost
                ? const Text('')
                : Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white,
                        size: 100,
                      ),
                    ),
                  )
          ]),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Consumer2<PostModel, UserModel>(
      builder: (context, postProvider, userProvider, child) => Padding(
        padding: const EdgeInsets.only(top: 40.0, right: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_outlined)),
            Text(
              S.of(context).forum_create,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            InkWell(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if (title.length > 10) {
                  setState(() {
                    isPost = false;
                  });
                  await postProvider.createPost(
                      title,
                      captions,
                      userProvider.userCurrent!.id,
                      userProvider.userCurrent!.name,
                      userProvider.userCurrent!.image,
                      _selectRoomId,
                      _selectedName,
                      tagSelect,
                      imagesChoose);
                  setState(() {
                    isPost = true;
                  });
                  setState(() {
                    Navigator.pop(context);
                  });
                } else {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: const Text('Title quá ngắn!'),
                    action: SnackBarAction(
                      label: 'Close',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Post ',
                  style:
                      GoogleFonts.readexPro(color: Colors.blue, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget caption(BuildContext context) {
    Widget spaceH = const SizedBox(
      height: 10,
    );
    Widget spaceW = const SizedBox(
      width: 5,
    );
    return Consumer<UserModel>(
      builder: (context, userProvider, child) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    imageUrl: userProvider.userCurrent!.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                spaceW,
                Text(
                  userProvider.userCurrent!.name,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            spaceH,
            spaceH,
            Row(
              children: [
                Text(S.of(context).forum_create_title,
                    style: GoogleFonts.readexPro(
                        fontSize: 17, fontWeight: FontWeight.w400)),
                spaceW,
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      title = value;
                    },
                    maxLines: null,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 16),
                    cursorColor: Colors.blue,
                    decoration:  InputDecoration(
                      hintText: S.of(context).forum_type_title,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            spaceH,
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      captions = value;
                    },
                    maxLines: null,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 16),
                    cursorColor: Colors.blue,
                    decoration:  InputDecoration(
                      hintText: S.of(context).forum_type_caption,
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blue,
                      size: 30,
                    ))
              ],
            ),
            spaceH,
            SizedBox(
              height: 35,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        tagSelect = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: tagSelect == 0
                              ? Colors.orange.withOpacity(0.7)
                              : Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tag,
                            color:
                                tagSelect == 0 ? Colors.white : Colors.orange,
                          ),
                          Text(
                            S.of(context).forum_roommate,
                            style: tagSelect == 0
                                ? GoogleFonts.readexPro(color: Colors.white)
                                : GoogleFonts.readexPro(color: Colors.orange),
                          )
                        ],
                      ),
                    ),
                  ),
                  spaceW,
                  InkWell(
                    onTap: () {
                      setState(() {
                        tagSelect = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: tagSelect == 1
                              ? Colors.orange.withOpacity(0.7)
                              : Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tag,
                            color:
                                tagSelect == 1 ? Colors.white : Colors.orange,
                          ),
                          Text(
                            S.of(context).forum_transfer,
                            style: tagSelect == 1
                                ? GoogleFonts.readexPro(color: Colors.white)
                                : GoogleFonts.readexPro(color: Colors.orange),
                          )
                        ],
                      ),
                    ),
                  ),
                  spaceW,
                  InkWell(
                    onTap: () {
                      setState(() {
                        tagSelect = 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: tagSelect == 2
                              ? Colors.orange.withOpacity(0.7)
                              : Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.tag,
                            color:
                                tagSelect == 2 ? Colors.white : Colors.orange,
                          ),
                          Text(
                            S.of(context).forum_other,
                            style: tagSelect == 2
                                ? GoogleFonts.readexPro(color: Colors.white)
                                : GoogleFonts.readexPro(color: Colors.orange),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget images(BuildContext context) {
    int photoCount = imagesChoose.length;
    if (photoCount == 1) {
      return FutureBuilder<File?>(
        future: imagesChoose[0].file,
        builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
          if (snapshot.hasData) {
            return Image.file(
              snapshot.data!,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            );
          } else {
            return const SizedBox();
          }
        },
      );
    } else if (photoCount == 2) {
      return Row(
        children: [
          FutureBuilder<File?>(
            future: imagesChoose[0].file,
            builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
              if (snapshot.hasData) {
                return Image.file(
                  snapshot.data!,
                  width: MediaQuery.of(context).size.width / 2 - 2,
                  height: MediaQuery.of(context).size.width / 2 - 4,
                  fit: BoxFit.cover,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(
            width: 4,
          ),
          FutureBuilder<File?>(
            future: imagesChoose[1].file,
            builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
              if (snapshot.hasData) {
                return Image.file(
                  snapshot.data!,
                  width: MediaQuery.of(context).size.width / 2 - 2,
                  height: MediaQuery.of(context).size.width / 2 - 4,
                  fit: BoxFit.cover,
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      );
    } else if (photoCount == 3) {
      return Row(
        children: [
          FutureBuilder<File?>(
            future: imagesChoose[0].file,
            builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
              if (snapshot.hasData) {
                return Image.file(
                  snapshot.data!,
                  width: MediaQuery.of(context).size.width / 2 - 2,
                  height: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          const SizedBox(
            width: 4,
          ),
          Column(
            children: [
              FutureBuilder<File?>(
                future: imagesChoose[1].file,
                builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                  if (snapshot.hasData) {
                    return Image.file(
                      snapshot.data!,
                      width: MediaQuery.of(context).size.width / 2 - 2,
                      height: MediaQuery.of(context).size.width / 2 - 2,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(
                height: 4,
              ),
              FutureBuilder<File?>(
                future: imagesChoose[2].file,
                builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                  if (snapshot.hasData) {
                    return Image.file(
                      snapshot.data!,
                      width: MediaQuery.of(context).size.width / 2 - 2,
                      height: MediaQuery.of(context).size.width / 2 - 2,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ],
      );
    } else if (photoCount == 4) {
      return Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          ...[0, 1, 2, 3].map((e) => FutureBuilder<File?>(
                future: imagesChoose[e].file,
                builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                  if (snapshot.hasData) {
                    return Image.file(
                      snapshot.data!,
                      width: MediaQuery.of(context).size.width / 2 - 2,
                      height: MediaQuery.of(context).size.width / 2 - 2,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ))
        ],
      );
    } else if (photoCount == 5) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...[0, 1].map((e) => FutureBuilder<File?>(
                    future: imagesChoose[e].file,
                    builder:
                        (BuildContext context, AsyncSnapshot<File?> snapshot) {
                      if (snapshot.hasData) {
                        return Image.file(
                          snapshot.data!,
                          width: MediaQuery.of(context).size.width / 2 - 2,
                          height: MediaQuery.of(context).size.width / 2 - 2,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ))
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...[2, 3, 4].map((e) => FutureBuilder<File?>(
                    future: imagesChoose[e].file,
                    builder:
                        (BuildContext context, AsyncSnapshot<File?> snapshot) {
                      if (snapshot.hasData) {
                        return Image.file(
                          snapshot.data!,
                          width: MediaQuery.of(context).size.width / 3 - 3,
                          height: MediaQuery.of(context).size.width / 3 - 3,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ))
            ],
          ),
        ],
      );
    } else {
      return Wrap(
        runSpacing: 4,
        spacing: 4,
        children: [
          ...[0, 1, 2, 3].map((e) => FutureBuilder<File?>(
                future: imagesChoose[e].file,
                builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                  if (snapshot.hasData) {
                    return Stack(children: [
                      Opacity(
                        opacity: e == 3 ? 0.6 : 1,
                        child: Image.file(
                          snapshot.data!,
                          width: MediaQuery.of(context).size.width / 2 - 2,
                          height: MediaQuery.of(context).size.width / 2 - 2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      e == 3
                          ? Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                  child: Text(
                                "${photoCount - 4}+",
                                style: GoogleFonts.readexPro(
                                    color: Colors.white, fontSize: 20),
                              )))
                          : const Text('')
                    ]);
                  } else {
                    return const SizedBox();
                  }
                },
              ))
        ],
      );
    }

    // return Row(
    //   children: [
    //     Expanded(
    //       flex: 1,
    //       child: FutureBuilder<File?>(
    //         future: imagesChoose[0].file,
    //         builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
    //           if (snapshot.hasData) {
    //             return Image.file(snapshot.data!,width: MediaQuery.of(context).size.width/2-4,height:MediaQuery.of(context).size.width/2-4 ,fit: BoxFit.cover,);
    //           } else {
    //             return const SizedBox();
    //           }
    //         },
    //       ),
    //     ),
    //     const SizedBox(width: 4),
    //     Expanded(
    //       flex: 1,
    //       child: FutureBuilder<File?>(
    //         future: widget.images![1].file,
    //         builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
    //           if (snapshot.hasData) {
    //             return Image.file(snapshot.data!,width: MediaQuery.of(context).size.width/2-4,height:MediaQuery.of(context).size.width/2-4 ,fit: BoxFit.cover);
    //           } else {
    //             return const SizedBox();
    //           }
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget location(BuildContext context) {
    return Consumer<RoomModel>(
      builder: (context, roomProvider, child) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                _dialogBuilder(context, await roomProvider.getListNameRoom());
              },
              icon: const Icon(
                Icons.location_on,
                color: Colors.orange,
                size: 30,
              ),
            ),
            Expanded(
                child: Text(
              _selectedName.toString(),
              style: GoogleFonts.readexPro(),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, List items) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Center(
                  child: Text(
                    S.of(context).forum_choose_place,
                style: Theme.of(context).textTheme.displayLarge,
              )),
              content: Container(
                width: 400,
                height: 400,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        items[index]['name'],
                        style: GoogleFonts.readexPro(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      selected: items[index]['name'] == _selectedName,
                      onTap: () {
                        setState(() {
                          _selectRoomId = items[index]['id'];
                          _selectedName = items[index]['name'];
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 10, top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Text(
                      'Confirm',
                      style: GoogleFonts.readexPro(color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          );
        });
  }
}
