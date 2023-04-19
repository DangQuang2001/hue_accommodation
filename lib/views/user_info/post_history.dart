import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hue_accommodation/view_models/post_provider.dart';
import 'package:hue_accommodation/views/components/slide_route.dart';
import 'package:hue_accommodation/views/forum/post_detail.dart';
import 'package:provider/provider.dart';

import '../../view_models/user_provider.dart';

class PostHistory extends StatefulWidget {
  const PostHistory({Key? key}) : super(key: key);

  @override
  State<PostHistory> createState() => _PostHistoryState();
}

class _PostHistoryState extends State<PostHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), content(context)],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_outlined,
              size: 30,
            ),
          ),
          Text(
            'My Post',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    return Consumer2<PostProvider, UserProvider>(
      builder: (context, postProvider, userProvider, child) => Expanded(
        child: FutureBuilder(
          future: postProvider.getPostById(userProvider.userCurrent!.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Bạn không có bài post nào'),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.of(context).push(slideRightToLeft(
                      PostDetailPage(post: snapshot.data![index]))),
                  child: Container(
                    height: 340,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Flex(
                        direction: Axis.vertical,
                        children: [
                          Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data![index].imageUrls![0],
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Text(
                                    snapshot.data![index].title,
                                    maxLines: 2,
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
                                      const Icon(Icons.date_range_outlined),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data![index].createdAt
                                            .toString()
                                            .split(" ")[0],
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.favorite_border_outlined),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            snapshot.data![index].likesCount
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Icon(Icons.message_outlined),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            snapshot.data![index].commentsCount
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          )
                                        ],
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _dialogBuilder(
                                                context,
                                                snapshot
                                                    .data![index].isHiddenHost,snapshot
                                                .data![index].id);
                                          },
                                          icon:
                                              snapshot.data![index].isHiddenHost
                                                  ? const Icon(
                                                      Icons.group_off_outlined,
                                                      color: Colors.red,
                                                    )
                                                  : const Icon(
                                                      Icons.group_outlined,
                                                      color: Colors.blue,
                                                    ))
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, bool isHidden,String postId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<UserProvider,PostProvider>(
          builder: (context, userProvider,postProvider, child) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title:isHidden?Center(
                child: Text(
                  'Tắt ẩn bài viết trên diễn đàn',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ) :Center(
                child: Text(
                  'Ẩn bài viết trên diễn đàn',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              content: SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: (){
                      postProvider.hiddenHost(postId, !isHidden, userProvider.userCurrent!.id);
                      setState(() {
                        Navigator.pop(context);
                      });
                    }, child: const Center(
                      child: Text('Confirm'),
                    )),
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Center(
                      child: Text('Cancel'),
                    )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
