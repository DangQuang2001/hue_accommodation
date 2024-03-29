import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/chat_view_model.dart';
import 'package:hue_accommodation/view_models/post_view_model.dart';
import 'package:hue_accommodation/views/components/layout.dart';
import 'package:hue_accommodation/views/forum/create_post.dart';
import 'package:hue_accommodation/views/forum/post.dart';
import 'package:provider/provider.dart';


import '../../generated/l10n.dart';
import '../../view_models/user_view_model.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _selectedColor = const Color(0xff1a73e8);
  final _unselectedColor = const Color(0xff5f6368);
  final _tabs = [
     Tab(
      text: S.current.forum_all,
    ),
     Tab(text: S.current.forum_roommate),
     Tab(text: S.current.forum_transfer),
     Tab(text: S.current.forum_other),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    var postProvider = Provider.of<PostViewModel>(context, listen: false);
    var userProvider = Provider.of<UserViewModel>(context, listen: false);
    postProvider.getAllData(userProvider.userCurrent!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [appBar(context), categories(context)],
      ),
    ));
  }

  Widget appBar(BuildContext context) {
    return Consumer3<UserViewModel,ChatViewModel,PostViewModel>(
      builder: (context, userProvider,chatProvider,postProvider, child) => Container(
        height: 160,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).colorScheme.onBackground,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SlideInRight(
                    duration: const Duration(milliseconds: 400),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(S.of(context).forum_title,
                            style: Theme.of(context).textTheme.headlineLarge),
                      ],
                    ),
                  ),
                  SlideInRight(
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Theme.of(context).colorScheme.onSecondary),
                          child: Icon(Icons.search_sharp,
                              color: Theme.of(context).iconTheme.color, size: 27),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Stack(children: [
                          GestureDetector(
                            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const Layout(selectedIndex: 1,))),
                            child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color:
                                        Theme.of(context).colorScheme.onSecondary),
                                child: Icon(Icons.message_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                    size: 24),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red),
                              child: Center(
                                  child: Text(
                                chatProvider.countNewChat.toString(),
                                style: GoogleFonts.readexPro(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              )),
                            ),
                          )
                        ])
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SlideInRight(
                    duration: const Duration(milliseconds: 400),
                    child: Row(
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
                        const SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreatePostPage())),
                          child: Text(
                            S.of(context).forum_post_something,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SlideInRight(
                    duration: const Duration(milliseconds: 500),
                    child: IconButton(
                        onPressed: () async {
                          await postProvider.selectImages(context);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreatePostPage(
                                        images: postProvider.images,
                                      )));
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Color.fromRGBO(1, 138, 221, 1.0),
                          size: 35,
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget categories(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 7.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: TabBar(

                isScrollable: true,
                controller: _tabController,
                tabs: _tabs,
                labelColor: _selectedColor,
                indicatorColor: _selectedColor,
                unselectedLabelColor: _unselectedColor,
                labelStyle: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            Expanded(
              child: TabBarView(

                controller: _tabController,
                children: [
                  allPost(context),
                  roommate(context),
                  transfer(context),
                  others(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget allPost(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, postProvider, child) {
        if(postProvider.listAllPost.isNotEmpty){
          return ListView(
            padding: const EdgeInsets.only(top: 5),
            shrinkWrap: true,
            children: [
              ...postProvider.listAllPost.map((e) => SlideInRight(
                  duration: const Duration(milliseconds: 400),child: PostCard(post: e)))
            ],
          );
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
      } ,
    );
  }
  Widget roommate(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, postProvider, child) {
        if(postProvider.listRoommate.isNotEmpty){
          return ListView(
            padding: const EdgeInsets.only(top: 5),
            shrinkWrap: true,
            children: [
              ...postProvider.listRoommate.map((e) => PostCard(post: e))
            ],
          );
        }
        else{
          return const Center(child: Text('Không có bài viết!'));
        }
      } ,
    );
  }
  Widget transfer(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, postProvider, child) {
        if(postProvider.listTransfer.isNotEmpty){
          return ListView(
            padding: const EdgeInsets.only(top: 5),
            shrinkWrap: true,
            children: [
              ...postProvider.listTransfer.map((e) => PostCard(post: e))
            ],
          );
        }
        else{
          return const Center(child: Text('Không có bài viết!'));
        }
      } ,
    );
  }
  Widget others(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, postProvider, child) {
        if(postProvider.listOther.isNotEmpty){
          return ListView(
            padding: const EdgeInsets.only(top: 5),
            shrinkWrap: true,
            children: [
              ...postProvider.listOther.map((e) => PostCard(post: e))
            ],
          );
        }
        else{
          return const Center(child: Text('Không có bài viết!'));
        }
      } ,
    );
  }

}
