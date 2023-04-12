import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../../models/post.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int choose = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          appBar(context),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                post(context),
                const SizedBox(
                  height: 5,
                ),
                comment(context)
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.bottomCenter,
      width: MediaQuery.of(context).size.width,
      height: 80,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.onBackground),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Theme.of(context).iconTheme.color,
              )),
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.message_outlined,
                size: 30,
                color: Theme.of(context).iconTheme.color,
              )),
        ],
      ),
    );
  }

  Widget post(BuildContext context) {
    Widget spaceH = const SizedBox(
      height: 10,
    );
    Widget spaceW = const SizedBox(
      width: 5,
    );
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      width: MediaQuery.of(context).size.width,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.onBackground),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  imageUrl: widget.post.avatar.toString(),
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
              ),
              spaceW,
              Text(
                widget.post.hostName,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 18),
              ),
              spaceW,
              spaceW,
              spaceW,
              Icon(
                Icons.access_time_outlined,
                size: 18,
                color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
              ),
              spaceW,
              Opacity(
                  opacity: 0.5,
                  child: Text(
                    time_ago.format(widget.post.createdAt,
                        locale: 'en_short', clock: DateTime.now()),
                    style: Theme.of(context).textTheme.displaySmall,
                  )),
            ],
          ),
          spaceH,
          Text(
            widget.post.caption.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.readexPro(
                fontWeight: FontWeight.w500, fontSize: 20),
          ),
          spaceH,
          spaceH,
          Opacity(
            opacity: 0.7,
            child: Text(
              "Mình có thuê 1 phòng trọ ở Tuy Lý Vương Huế với giá 5 triệu. Phòng to 2 người dư đủ, đầy đủ tiện nghi: Điều hòa, wifi, bể bơi ...",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 15.5),
            ),
          ),
          spaceH,
          spaceH,
          viewImage(context,widget.post.imageUrls!),
          spaceH,
          Row(
            children: [
              Icon(
                Icons.favorite_border_outlined,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
              spaceW,
              Text(
                widget.post.likesCount.toString(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              spaceW,
              spaceW,
              spaceW,
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  )),
              spaceW,
              Text(
                widget.post.commentsCount.toString(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget viewImage(BuildContext context, List<String> imagesChoose) {
    int photoCount = imagesChoose.length;
    if (photoCount == 1) {
      return CachedNetworkImage(
        imageUrl: imagesChoose[0].toString(),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      );
    } else if (photoCount == 2) {
      return Row(
        children: [
          CachedNetworkImage(
            imageUrl: imagesChoose[0].toString(),
            width: MediaQuery.of(context).size.width / 2 - 22,
            height: MediaQuery.of(context).size.width / 2 - 4,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 4,
          ),
          CachedNetworkImage(
            imageUrl: imagesChoose[1].toString(),
            width: MediaQuery.of(context).size.width / 2 - 22,
            height: MediaQuery.of(context).size.width / 2 - 4,
            fit: BoxFit.cover,
          )
        ],
      );
    } else if (photoCount == 3) {
      return Row(
        children: [
          CachedNetworkImage(
            imageUrl: imagesChoose[0].toString(),
            width: MediaQuery.of(context).size.width / 2 - 22,
            height: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 4,
          ),
          Column(
            children: [
              CachedNetworkImage(
                imageUrl: imagesChoose[1].toString(),
                width: MediaQuery.of(context).size.width / 2 - 22,
                height: MediaQuery.of(context).size.width / 2 - 2,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 4,
              ),
              CachedNetworkImage(
                imageUrl: imagesChoose[2].toString(),
                width: MediaQuery.of(context).size.width / 2 - 22,
                height: MediaQuery.of(context).size.width / 2 - 2,
                fit: BoxFit.cover,
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
          ...[0, 1, 2, 3].map((e) => CachedNetworkImage(
            imageUrl: imagesChoose[e].toString(),
            width: MediaQuery.of(context).size.width / 2 - 22,
            height: MediaQuery.of(context).size.width / 2 - 2,
            fit: BoxFit.cover,
          ))
        ],
      );
    } else if (photoCount == 5) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...[0, 1].map((e) => CachedNetworkImage(
                imageUrl: imagesChoose[e].toString(),
                width: MediaQuery.of(context).size.width / 2 - 22,
                height: MediaQuery.of(context).size.width / 2 - 2,
                fit: BoxFit.cover,
              ))
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...[2, 3, 4].map((e) => CachedNetworkImage(
                imageUrl: imagesChoose[e].toString(),
                width: MediaQuery.of(context).size.width / 3 - 16,
                height: MediaQuery.of(context).size.width / 3 - 3,
                fit: BoxFit.cover,
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
          ...[0, 1, 2, 3].map((e) => Stack(children: [
            Opacity(
              opacity: e == 3 ? 0.6 : 1,
              child: CachedNetworkImage(
                imageUrl: imagesChoose[e].toString(),
                width: MediaQuery.of(context).size.width / 2 - 22,
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
          ]))
        ],
      );
    }

    // return Row(
    //   children: [
    //     Expanded(
    //       flex: 1,
    //       child: FutureBuilder<String?>(
    //         future: imagesChoose[0].file,
    //         builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
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
    //       child: FutureBuilder<String?>(
    //         future: widget.images![1].file,
    //         builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
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

  Widget comment(BuildContext context) {
    Widget spaceH = const SizedBox(
      height: 10,
    );
    Widget spaceW = const SizedBox(
      width: 5,
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.onBackground),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10.0, right: 20, left: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comment',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ExpansionPanelList(
              dividerColor: Colors.grey.withOpacity(0.2),
              elevation: 0,
              animationDuration: const Duration(milliseconds: 500),
              children: [
                ...[1, 2, 3, 4].map((e) {
                  int indexX = [1, 2, 3, 4].indexOf(e);
                  return ExpansionPanel(
                      backgroundColor:
                          Theme.of(context).colorScheme.onBackground,
                      hasIcon: false,
                      isExpanded: choose == indexX,
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (choose != indexX) {
                                      setState(() {
                                        choose = indexX;
                                      });
                                    } else {
                                      setState(() {
                                        choose = -1;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.comment_outlined)),
                              Opacity(
                                opacity: 0.7,
                                child: Text(
                                  '3',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ),
                            ],
                          ),
                          minVerticalPadding: 0,
                          title: Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://www.invert.vn/media/uploads/uploads/2022/12/03191304-8-anh-gai-xinh-toc-dai.jpeg',
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    spaceW,
                                    Text(
                                      'Dieu Hoang',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    spaceW,
                                    spaceW,
                                    spaceW,
                                    Icon(
                                      Icons.access_time_outlined,
                                      size: 18,
                                      color: Theme.of(context)
                                          .iconTheme
                                          .color!
                                          .withOpacity(0.5),
                                    ),
                                    spaceW,
                                    Opacity(
                                        opacity: 0.5,
                                        child: Text(
                                          '1m ago',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        )),
                                  ],
                                ),
                                spaceH,
                                Row(
                                  children: [
                                    Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        'Có người ghép đôi chưa cậu.',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      body: Container(
                        width: 100,
                        height: 100,
                        color: Colors.red,
                      ));
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
