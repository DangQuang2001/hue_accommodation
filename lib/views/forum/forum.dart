import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/post_provider.dart';
import 'package:hue_accommodation/views/forum/create_post.dart';
import 'package:hue_accommodation/views/forum/post.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
    const Tab(
      text: 'All Discussion',
    ),
    const Tab(text: 'Roommate'),
    const Tab(text: 'Transfer of property'),
    const Tab(text: 'Others'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    var postProvider = Provider.of<PostProvider>(context, listen: false);
    postProvider.getPost([0, 1, 2, 3], 's');
    super.initState();
  }

  List<AssetEntity> _images = [];

  Future<void> _selectImages() async {
    List<AssetEntity>? result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.image,
          selectedAssets: [],
        ));
    setState(() {
      _images = result!;
    });
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
    return Container(
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
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('Forum',
                        style: Theme.of(context).textTheme.headlineLarge),
                  ],
                ),
                Row(
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
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Theme.of(context).colorScheme.onSecondary),
                          child: Icon(Icons.message_outlined,
                              color: Theme.of(context).iconTheme.color,
                              size: 24),
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
                            '3',
                            style: GoogleFonts.readexPro(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )),
                        ),
                      )
                    ])
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        'https://bedental.vn/wp-content/uploads/2022/11/hot-girl_8-683x1024.jpg',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      'Post something for forum?',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      await _selectImages();
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreatePostPage(
                                    images: _images,
                                  )));
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Color.fromRGBO(1, 138, 221, 1.0),
                      size: 35,
                    ))
              ],
            )
          ],
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
                  content(context),
                  content(context),
                  content(context),
                  content(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) => ListView(
        padding: const EdgeInsets.only(top: 5),
        shrinkWrap: true,
        children: [...postProvider.listPost.map((e) => PostCard(post: e))],
      ),
    );
  }


}
