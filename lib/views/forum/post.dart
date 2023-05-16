import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/chat_view_model.dart';
import 'package:hue_accommodation/views/forum/post_detail.dart';
import 'package:hue_accommodation/views/messages/message_detail.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as time_ago;
import '../../models/post.dart';
import '../../view_models/post_view_model.dart';
import '../../view_models/user_view_model.dart';
import '../components/slide_route.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isLike;
  late int likeCount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userProvider = Provider.of<UserViewModel>(context, listen: false);
    isLike = widget.post.likedBy!.contains(userProvider.userCurrent!.id);
    likeCount = widget.post.likedBy!.length;
  }

  @override
  Widget build(BuildContext context) {
    Widget spaceH = const SizedBox(
      height: 10,
    );
    Widget spaceW = const SizedBox(
      width: 5,
    );
    return Consumer3<PostViewModel, UserViewModel, ChatViewModel>(
      builder: (context, postProvider, userProvider, chatProvider, child) =>
          GestureDetector(
        onTap: () => Navigator.of(context).push(slideRightToLeft(PostDetailPage(
          post: widget.post,
        ))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 7),
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.onBackground,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).push(slideRightToLeft(PostDetailPage(
                    post: widget.post,
                  ))),
                  child: Text(
                    widget.post.title.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.readexPro(
                        fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
                spaceH,
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
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    spaceW,
                    spaceW,
                    spaceW,
                    Icon(
                      Icons.access_time_outlined,
                      size: 18,
                      color:
                          Theme.of(context).iconTheme.color!.withOpacity(0.5),
                    ),
                    spaceW,
                    Opacity(
                        opacity: 0.5,
                        child: Text(
                          time_ago.format(widget.post.createdAt,
                              locale: 'en_short', clock: DateTime.now()),
                          style: Theme.of(context).textTheme.displaySmall,
                        )),
                    const Spacer(),
                    widget.post.userId==userProvider.userCurrent!.id?const Text('') :IconButton(
                        onPressed: () async {
                          await chatProvider.checkRoom([
                            userProvider.userCurrent!.id,
                            widget.post.userId
                          ]);

                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(slideRightToLeft(
                              ChatScreen(
                                  isNewRoom: chatProvider.isNewRoom,
                                  roomId: chatProvider.isNewRoom
                                      ? ""
                                      : chatProvider.roomId,
                                  infoUserRoom: chatProvider.infoUserRoom)));
                        },
                        icon: const Icon(
                          Icons.chat,
                          color: Colors.blue,
                          size: 25,
                        )),
                    spaceW
                  ],
                ),
                spaceH,
                widget.post.imageUrls!.isEmpty
                    ? const SizedBox()
                    : InkWell(
                        onTap: () => Navigator.of(context).push(slideRightToLeft(PostDetailPage(
                          post: widget.post,
                        ))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: widget.post.imageUrls![0],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                        onPressed: () => Navigator.of(context).push(slideRightToLeft(PostDetailPage(
                          post: widget.post,
                        ))),
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
        ),
      ),
    );
  }
}
