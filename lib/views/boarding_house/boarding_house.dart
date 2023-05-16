import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/constants/route_name.dart';
import 'package:hue_accommodation/view_models/room_view_model.dart';
import 'package:hue_accommodation/views/boarding_house/filter_house.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../generated/l10n.dart';
import '../../models/room.dart';
import '../components/slide_route.dart';
import 'boarding_house_detail.dart';

class BoardingHousePage extends StatefulWidget {
  const BoardingHousePage({Key? key}) : super(key: key);

  @override
  State<BoardingHousePage> createState() => _BoardingHousePageState();
}

class _BoardingHousePageState extends State<BoardingHousePage>
    with SingleTickerProviderStateMixin {
  List<Room> listRoom = [];
  Timer? _timer;
  int currentPage = 0;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(initialPage: 0);
  final _selectedColor = const Color(0xff1a73e8);
  final _unselectedColor = const Color(0xff5f6368);
  final _tabs = [
     Tab(
      text: S.current.boardinghouse_mini_house,
    ),
     Tab(text: S.current.boardinghouse_motel_house),
     Tab(text: S.current.boardinghouse_whole_house),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    var roomProvider = Provider.of<RoomViewModel>(context, listen: false);
    if (roomProvider.listMiniFirstLoad.isEmpty) {
      roomProvider.getDataFirstTime();
      (()async{
        var connectivityResult =
        await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          roomProvider.getListNoInternet();
        }
      })();
    }
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: Consumer<RoomViewModel>(
        builder: (context, roomProvider, child) =>
            NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollEndNotification &&
                scrollInfo.metrics.extentAfter == 0) {
              (()async{
                var connectivityResult =
                await Connectivity().checkConnectivity();
                if (connectivityResult == ConnectivityResult.mobile ||
                    connectivityResult == ConnectivityResult.wifi) {
                  roomProvider.lazyLoading();
                }
              })();
            }
            return true;
          },
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),

                  title: Hero(
                    tag: "Boarding Houses",
                    child: Text(
                      S.of(context).boardinghouse_title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 5,

                  leading: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  actions: const [
                    SizedBox(
                      width: 30,
                    )
                  ],
                  backgroundColor: Theme.of(context).colorScheme.background,
                  iconTheme: IconThemeData(
                      color: Theme.of(context).iconTheme.color, size: 30),
                  // config for SliverAppBar
                  expandedHeight: 770.0,
                  floating: false,
                  pinned: true,
                  stretch: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(70.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TabBar(
                        controller: _tabController,
                        tabs: _tabs,
                        labelColor: _selectedColor,
                        indicatorColor: _selectedColor,
                        unselectedLabelColor: _unselectedColor,
                        labelStyle: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Padding(
                        padding: const EdgeInsets.only(top: 90.0),
                        child: Column(
                          children: [
                            slider(context),
                            categories(context),
                            hot(context),
                          ],
                        ),
                      )),
                ),
              ];
            },
            body: filter(context),
          ),
        ),
      ),
    );
  }

  Widget search(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 40.0, left: 20, right: 20, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 30,
                ),
              ),
            ),
          ),
          Hero(
            tag: "Boarding Houses",
            child: Text(
              'Boarding Houses',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, RouteName.boardinghousedetail),
            child: const Icon(
              Icons.filter_list_outlined,
              size: 27,
            ),
          )
        ],
      ),
    );
  }

  Widget filter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                listItemMini(context),
                listItemMotel(context),
                listItemWhole(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listItemMini(BuildContext context) {
    return Consumer<RoomViewModel>(
        builder: (context, roomProvider, child) => ListView(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: roomProvider.listMiniFirstLoad.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () => Navigator.of(context).push(slideRightToLeft(BoardingHouseDetail(
                              motel: roomProvider
                                  .listMiniFirstLoad[index]))),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            color: Theme.of(context).colorScheme.onBackground,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Row(
                                children: [
                                  Stack(children: [
                                    Hero(
                                      tag: roomProvider
                                          .listMiniFirstLoad[index].image,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Banner(
                                          textStyle: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 11),
                                          message: roomProvider
                                                      .listMiniFirstLoad[index]
                                                      .hasRoom ==
                                                  true
                                              ? 'Còn phòng'
                                              : 'Hết phòng',
                                          color: roomProvider
                                                      .listMiniFirstLoad[index]
                                                      .hasRoom ==
                                                  true
                                              ? Colors.green
                                              : Colors.red,
                                          location: BannerLocation.topEnd,
                                          child: CachedNetworkImage(
                                            imageUrl: roomProvider
                                                .listMiniFirstLoad[index].image,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            fit: BoxFit.cover,
                                            errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg',fit: BoxFit.cover,)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            roomProvider
                                                .listMiniFirstLoad[index].name,
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
                                              const Icon(
                                                Icons.attach_money_outlined,
                                                color: Colors.orange,
                                                size: 20,
                                              ),
                                              Text(
                                                roomProvider
                                                                .listMiniFirstLoad[
                                                                    index]
                                                                .adParams[
                                                            'deposit'] ==
                                                        null
                                                    ? "0 đ"
                                                    : roomProvider
                                                            .listMiniFirstLoad[
                                                                index]
                                                            .adParams['deposit']
                                                        ['value'],
                                                style: GoogleFonts.readexPro(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.orangeAccent),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  roomProvider
                                                          .listMiniFirstLoad[index]
                                                          .adParams['address']
                                                      ['value'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.description,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  roomProvider
                                                      .listMiniFirstLoad[index]
                                                      .description,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                if (roomProvider.isLoadMoreRunning == true)
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Shimmer.fromColors(
                        baseColor: const Color(0xffc8c8c8),
                        highlightColor: const Color(0xff8b8b8b),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  width: MediaQuery.of(context).size.width / 2 -
                                      40,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  width: MediaQuery.of(context).size.width / 2 -
                                      60,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: MediaQuery.of(context).size.width / 2 -
                                      40,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (roomProvider.isLoadMoreRunning == true)
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Shimmer.fromColors(
                        baseColor: const Color(0xffc8c8c8),
                        highlightColor: const Color(0xff8b8b8b),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  width: MediaQuery.of(context).size.width / 2 -
                                      40,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  width: MediaQuery.of(context).size.width / 2 -
                                      60,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  width: MediaQuery.of(context).size.width / 2 -
                                      40,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ));
  }

  Widget listItemMotel(BuildContext context) {
    return Consumer<RoomViewModel>(
        builder: (context, roomProvider, child) => ListView(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: roomProvider.listMotelFirstLoad.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () => Navigator.of(context).push(slideRightToLeft(BoardingHouseDetail(
                              motel: roomProvider
                                  .listMotelFirstLoad[index]))),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            color: Theme.of(context).colorScheme.onBackground,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Row(
                                children: [
                                  Stack(children: [
                                    Hero(
                                      tag: roomProvider
                                          .listMotelFirstLoad[index].image,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Banner(
                                          textStyle: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 11),
                                          message: roomProvider
                                                      .listMotelFirstLoad[index]
                                                      .hasRoom ==
                                                  true
                                              ? 'Còn phòng'
                                              : 'Hết phòng',
                                          color: roomProvider
                                                      .listMotelFirstLoad[index]
                                                      .hasRoom ==
                                                  true
                                              ? Colors.green
                                              : Colors.red,
                                          location: BannerLocation.topEnd,
                                          child: CachedNetworkImage(
                                            imageUrl: roomProvider
                                                .listMotelFirstLoad[index]
                                                .image,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            fit: BoxFit.cover,
                                            errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg',fit: BoxFit.cover,)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            roomProvider
                                                .listMotelFirstLoad[index].name,
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
                                              const Icon(
                                                Icons.attach_money_outlined,
                                                color: Colors.orange,
                                                size: 20,
                                              ),
                                              Text(
                                                roomProvider
                                                                .listMotelFirstLoad[
                                                                    index]
                                                                .adParams[
                                                            'deposit'] ==
                                                        null
                                                    ? "0 đ"
                                                    : roomProvider
                                                            .listMotelFirstLoad[
                                                                index]
                                                            .adParams['deposit']
                                                        ['value'],
                                                style: GoogleFonts.readexPro(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.orangeAccent),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  roomProvider
                                                      .listMotelFirstLoad[index]
                                                      .adParams['address']['value'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.description,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  roomProvider
                                                      .listMotelFirstLoad[index]
                                                      .description,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
              ],
            ));
  }

  Widget listItemWhole(BuildContext context) {
    return Consumer<RoomViewModel>(
        builder: (context, roomProvider, child) => ListView(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: roomProvider.listWholeFirstLoad.length,
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () => Navigator.of(context).push(slideRightToLeft(BoardingHouseDetail(
                              motel: roomProvider
                                  .listWholeFirstLoad[index]))),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            color: Theme.of(context).colorScheme.onBackground,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Row(
                                children: [
                                  Stack(children: [
                                    Hero(
                                      tag: roomProvider
                                          .listWholeFirstLoad[index].image,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Banner(
                                          textStyle: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 11),
                                          message: roomProvider
                                                      .listWholeFirstLoad[index]
                                                      .hasRoom ==
                                                  true
                                              ? 'Còn phòng'
                                              : 'Hết phòng',
                                          color: roomProvider
                                                      .listWholeFirstLoad[index]
                                                      .hasRoom ==
                                                  true
                                              ? Colors.green
                                              : Colors.red,
                                          location: BannerLocation.topEnd,
                                          child: CachedNetworkImage(
                                            imageUrl: roomProvider
                                                .listWholeFirstLoad[index]
                                                .image,
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            fit: BoxFit.cover,
                                            errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg',fit: BoxFit.cover,)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            20,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, top: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            roomProvider
                                                .listWholeFirstLoad[index].name,
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
                                              const Icon(
                                                Icons.attach_money_outlined,
                                                color: Colors.orange,
                                                size: 20,
                                              ),
                                              Text(
                                                roomProvider
                                                                .listWholeFirstLoad[
                                                                    index]
                                                                .adParams[
                                                            'deposit'] ==
                                                        null
                                                    ? "0 đ"
                                                    : roomProvider
                                                            .listWholeFirstLoad[
                                                                index]
                                                            .adParams['deposit']
                                                        ['value'],
                                                style: GoogleFonts.readexPro(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.orangeAccent),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  roomProvider
                                                      .listWholeFirstLoad[index]
                                                      .adParams['address']['value'],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.description,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  roomProvider
                                                      .listWholeFirstLoad[index]
                                                      .description,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
              ],
            ));
  }

  Widget slider(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: imageList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl:
                imageList[index],
                fit: BoxFit.cover,
                errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg',fit: BoxFit.cover,)
              ),
            ),
          );
        },
      ),
    );
  }

  Widget hot(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, roomProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 10, top: 10),
            child: SlideInRight(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 200),
              child: Text(
                S.of(context).boardinghouse_top_rating,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          SizedBox(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 20,
                ),
                ...roomProvider.listTopRating.map((e) => GestureDetector(
                      onTap: () => Navigator.of(context).push(slideRightToLeft(BoardingHouseDetail(
                          motel:e))),
                      child: SlideInRight(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(right: 10),
                          width: 230,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: e.image,
                                    width: double.infinity,
                                    height: 130,
                                    fit: BoxFit.cover,
                                    errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg',fit: BoxFit.cover,)
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    width: 50,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.withOpacity(0.8)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          e.rating.toString(),
                                          style: GoogleFonts.readexPro(
                                              color: Colors.white),
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                            width: 170,
                                            child: Text(
                                              e.adParams['address']['value'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium,
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categories(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 20.0, left: 20, bottom: 10, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideInRight(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 200),
            child: Text(
              S.of(context).boardinghouse_explore,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).push(slideRightToLeft(const FilterHouse(typeName: 1))),
                child: SlideInRight(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://cdn-icons-png.flaticon.com/512/602/602270.png",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg',fit: BoxFit.cover,)
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        S.of(context).boardinghouse_rent,
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(slideRightToLeft(const FilterHouse(typeName: 2))),
                child: SlideInRight(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://cdn-icons-png.flaticon.com/512/1441/1441348.png",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        S.of(context).boardinghouse_buy,
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(slideRightToLeft(const FilterHouse(typeName: 3))),
                child: SlideInRight(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 400),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://cdn-icons-png.flaticon.com/512/1084/1084030.png",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        S.of(context).boardinghouse_project,
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.page == 2) {
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 2000), curve: Curves.ease);
      } else {
        _pageController.nextPage(
            duration: const Duration(milliseconds: 3000), curve: Curves.ease);
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _timer?.cancel();
    _timer = null;
  }

}
