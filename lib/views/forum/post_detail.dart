import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/comment_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../../models/post.dart';
import '../../view_models/post_provider.dart';
import '../../view_models/user_provider.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  int choose = -1;
  late bool isLike;
  late int likeCount;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var commentProvider = Provider.of<CommentProvider>(context, listen: false);
    commentProvider.getComment(widget.post.id, 10, 10);
    isLike = widget.post.likedBy!.contains(userProvider.userCurrent!.id);
    likeCount = widget.post.likedBy!.length;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _replyPrefix = '';
  String commentId = "";

  void onReply(String username) {
    setState(() {
      _replyPrefix = '@$username ';
      _textController.text = _replyPrefix;
      _textController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Consumer2<CommentProvider, UserProvider>(
        builder: (context, commentProvider, userProvider, child) => Column(
          children: [
            appBar(context),
            Expanded(
                child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  post(context),
                  const SizedBox(
                    height: 5,
                  ),
                  comment(context),
                ],
              ),
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              color: Theme.of(context).colorScheme.onBackground,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      autofocus: true,
                      focusNode: _focusNode,
                      controller: _textController,
                      decoration: InputDecoration(
                        enabled: true,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5))),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.6),
                        hintText: 'Enter a comment...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (_textController.text.trim() != "" &&
                          _replyPrefix == "" &&
                          commentId == "") {
                        await commentProvider.addComment(
                            widget.post.id,
                            userProvider.userCurrent!.id,
                            _textController.text,
                            "text");
                        _focusNode.unfocus();
                        _textController.clear();
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear);
                      }
                      if (_textController.text.trim() != "" &&
                          _replyPrefix != "" &&
                          commentId != "") {
                        commentProvider.createReplyComment(
                            commentId,
                            userProvider.userCurrent!.id,
                            _textController.text,
                            "Text");
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
    return Consumer2<PostProvider, UserProvider>(
      builder: (context, postProvider, userProvider, child) => Container(
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
              widget.post.title.toString(),
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
                widget.post.caption.toString(),
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
            widget.post.imageUrls!.isEmpty
                ? const SizedBox()
                : viewImage(context, widget.post.imageUrls!),
            spaceH,
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (isLike) {
                        postProvider.dislikePost(
                            widget.post.id, userProvider.userCurrent!.id);
                      } else {
                        postProvider.likePost(
                            widget.post.id, userProvider.userCurrent!.id);
                      }
                      setState(() {
                        isLike = !isLike;
                        likeCount += isLike ? 1 : -1;
                      });
                    },
                    icon: isLike
                        ? const Icon(
                            Icons.favorite_sharp,
                            color: Colors.redAccent,
                            size: 30,
                          )
                        : Icon(
                            Icons.favorite_border_outlined,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          )),
                spaceW,
                Text(
                  likeCount.toString(),
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
  }

  Widget comment(BuildContext context) {
    Widget spaceH = const SizedBox(
      height: 10,
    );
    Widget spaceW = const SizedBox(
      width: 5,
    );

    return Consumer<CommentProvider>(
      builder: (context, commentProvider, child) => Container(
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
                  ...commentProvider.listComment.map((e) {
                    int indexX = commentProvider.listComment.indexOf(e);
                    return ExpansionPanel(
                        hasIcon: false,
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                        // hasIcon: false,
                        isExpanded: choose == indexX,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (choose != indexX && e['replyCommentId'] != null) {
                                        setState(() {
                                          choose = indexX;
                                          onReply(e['userId']['name']);
                                          commentId = e['_id'];
                                          commentProvider.getReplyComment(e['_id'], 10, 10);
                                        });
                                      } else {
                                        setState(() {
                                          choose = -1;
                                          _textController.text = "";
                                          _replyPrefix = "";
                                          commentId = "";
                                        });
                                      }
                                      if(e['replyCommentId'] == null){
                                        commentId = e['_id'];
                                        onReply(e['userId']['name']);
                                      }
                                    },
                                    icon: const Icon(Icons.comment_outlined)),
                                Opacity(
                                  opacity: 0.7,
                                  child: Text(
                                    e['replyCommentId'] == null ? "0" : (e['replyCommentId']['comment']as List).length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ),
                              ],
                            ),
                            minVerticalPadding: 0,
                            title: Container(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: CachedNetworkImage(
                                          imageUrl: e['userId']['image'],
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      spaceW,
                                      Text(
                                        e['userId']['name'],
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
                                          e['content'],
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
                        body: Column(
                          children: [
                            ...commentProvider.listReply.map((e) => Container(
                                  margin: const EdgeInsets.only(
                                      left: 40, bottom: 20),
                                  padding: const EdgeInsets.only(left: 10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      border: Border(
                                          left: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.4)))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: CachedNetworkImage(
                                              imageUrl: e['userId']['image'],
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          spaceW,
                                          Text(
                                            e['userId']['name'],
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
                                              e['content'],
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
                                ))
                          ],
                        ));
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
