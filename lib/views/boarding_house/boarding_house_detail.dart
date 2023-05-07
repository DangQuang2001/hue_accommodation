import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_accommodation/view_models/chat_model.dart';
import 'package:hue_accommodation/view_models/google_map_model.dart';
import 'package:hue_accommodation/view_models/room_model.dart';
import 'package:hue_accommodation/view_models/user_model.dart';
import 'package:hue_accommodation/views/boarding_house/rent_now.dart';
import 'package:hue_accommodation/views/extension/navigation_map.dart';
import 'package:hue_accommodation/views/login_register/auth_service.dart';
import 'package:hue_accommodation/views/messages/message_detail.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/room.dart';
import '../../view_models/favourite_model.dart';

class BoardingHouseDetail extends StatefulWidget {
  final Room motel;

  const BoardingHouseDetail({Key? key, required this.motel}) : super(key: key);

  @override
  State<BoardingHouseDetail> createState() => _BoardingHouseDetailState();
}

class _BoardingHouseDetailState extends State<BoardingHouseDetail> {
  bool isCheckFavourite = false;
  int listImageLength = 10;
  final Completer<GoogleMapController> _controller = Completer();


  @override
  void initState() {
    super.initState();
    var favouriteProvider =
        Provider.of<FavouriteModel>(context, listen: false);
    var userProvider = Provider.of<UserModel>(context, listen: false);
    var googleMapProvider =
        Provider.of<GoogleMapModel>(context, listen: false);
    if (userProvider.userCurrent != null) {
      favouriteProvider.checkFavourite(widget.motel.roomId,
          Provider.of<UserModel>(context, listen: false).userCurrent!.id);
      isCheckFavourite = favouriteProvider.isCheckFavourite;
    }
    googleMapProvider.getMarker(_controller, LatLng(widget.motel.latitude, widget.motel.longitude));
  }

  @override
  void dispose() {
    _controller.future.then((value) => value.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Consumer3<UserModel, ChatModel, FavouriteModel>(
          builder:
              (context, userProvider, chatProvider, favouriteProvider, child) =>
                  NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
                  leading: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.5)),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    widget.motel.hostID ==
                            (userProvider.userCurrent == null
                                ? ""
                                : userProvider.userCurrent!.id)
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              if (userProvider.userCurrent == null) {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: const Text(
                                      'Bạn phải đăng nhập để sử dụng chức năng này!'),
                                  action: SnackBarAction(
                                    label: 'Đăng nhập',
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthService()
                                                      .handleAuthState()));
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                if (isCheckFavourite) {
                                  favouriteProvider.removeFavourite(
                                      widget.motel.roomId,
                                      userProvider.userCurrent!.id);
                                  setState(() {
                                    isCheckFavourite = false;
                                  });
                                } else {
                                  favouriteProvider.addFavourite(
                                      widget.motel.roomId,
                                      userProvider.userCurrent!.id);
                                  setState(() {
                                    isCheckFavourite = true;
                                  });
                                }
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.5)),
                                child: isCheckFavourite
                                    ? Icon(
                                        Icons.favorite_rounded,
                                        color:
                                            Colors.redAccent.withOpacity(0.9),
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    widget.motel.hostID ==
                            (userProvider.userCurrent == null
                                ? ""
                                : userProvider.userCurrent!.id)
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () async {
                              if (userProvider.userCurrent == null) {
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: const Text(
                                      'Bạn phải đăng nhập để sử dụng chức năng này!'),
                                  action: SnackBarAction(
                                    label: 'Đăng nhập',
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AuthService()
                                                      .handleAuthState()));
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                await chatProvider.checkRoom([
                                  userProvider.userCurrent!.id,
                                  widget.motel.hostID
                                ]);
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              isNewRoom: chatProvider.isNewRoom,
                                              roomId: chatProvider.isNewRoom
                                                  ? ""
                                                  : chatProvider.roomId,
                                              infoUserRoom:
                                                  chatProvider.infoUserRoom,
                                            )));
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.5)),
                                child: const Icon(
                                  Icons.message_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  iconTheme: IconThemeData(
                      color: Theme.of(context).iconTheme.color, size: 30),
                  // config for SliverAppBar
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  stretch: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(70.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 1.0],
                              colors: [
                                Colors.transparent,
                                Colors.grey.withOpacity(0.5),
                              ],
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 75,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        2 /
                                        3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.motel.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.readexPro(
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 2.0,
                                                  color: Colors.grey
                                                      .withOpacity(0.6),
                                                  offset: const Offset(2, 2),
                                                ),
                                              ],
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              2 /
                                              3,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  widget.motel
                                                          .adParams['address']
                                                      ['value'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.readexPro(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.white
                                                          .withOpacity(0.9)),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 65,
                                          height: 20,
                                          decoration: BoxDecoration(
                                              color: widget.motel.hasRoom ==
                                                      true
                                                  ? Colors.green
                                                      .withOpacity(0.9)
                                                  : Colors.red.withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                              child: Text(
                                            widget.motel.hasRoom == true
                                                ? "Còn phòng"
                                                : "Hết phòng",
                                            style: GoogleFonts.readexPro(
                                                color: Colors.white,
                                                fontSize: 10),
                                          )),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.yellow,
                                              size: 25,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              widget.motel.rating
                                                  .toStringAsFixed(1),
                                              style: GoogleFonts.readexPro(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),

                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: Hero(
                      tag: widget.motel.image,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl:
                          widget.motel.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Container(
              alignment: Alignment.topCenter,
              color: Theme.of(context).colorScheme.background,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listImage(context),
                    info(context),
                    map(context),
                    review(context)
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomBar(context)
      ]),
    );
  }

  Widget listImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: widget.motel.images.length < 4
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        children: [
          ...(widget.motel.images.length < 4
                  ? widget.motel.images
                  : [1, 2, 3, 4])
              .map((e) {
            int index = (widget.motel.images.length < 4
                    ? widget.motel.images
                    : [1, 2, 3, 4])
                .indexOf(e);

            return GestureDetector(
              onTap: () {
                _dialogBuilder(context, widget.motel.images);
              },
              child: Container(
                margin: widget.motel.images.length < 4
                    ? const EdgeInsets.only(right: 10)
                    : const EdgeInsets.only(right: 0),
                width: 85,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeMode == ThemeMode.light
                          ? Colors.grey.withOpacity(0.5)
                          : Colors.transparent,
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(2, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(alignment: Alignment.center, children: [
                    CachedNetworkImage(
                      imageUrl:
                      widget.motel.images[index],
                      width: 223,
                      height: 210,
                      fit: BoxFit.cover,
                      errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg'),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        color: (widget.motel.images.length > 4 && index == 3)
                            ? Colors.black.withOpacity(0.4)
                            : Colors.transparent,
                      ),
                    ),
                    Positioned(
                      child: (widget.motel.images.length > 4 && index == 3)
                          ? Text(
                              "${widget.motel.images.length - 4}+",
                              style: GoogleFonts.readexPro(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            )
                          : const Text(''),
                    )
                  ]),
                ),
              ),
            );
          })
        ],
      ),
    );
  }

  Widget info(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bed_outlined,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '2 ${S.of(context).boardinghouse_detail_bed}',
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.bathtub_outlined, size: 25),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '1 ${S.of(context).boardinghouse_detail_bath}',
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.area_chart_outlined, size: 25),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.motel.adParams['size']['value'].toString(),
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            S.of(context).boardinghouse_detail_description,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10),
            child: Opacity(
              opacity: 0.8,
              child: ExpandableText(
                widget.motel.description,
                expandText: 'More',
                expandOnTextTap: true,
                maxLines: 5,
                animation: true,
                animationDuration: const Duration(milliseconds: 1000),
                linkColor: Colors.blue,
                collapseOnTextTap: true,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget map(BuildContext context) {
    return Consumer<GoogleMapModel>(
      builder: (context, googleMapProvider, child) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 350,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  zoomControlsEnabled: false,
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId("route"),
                        points: googleMapProvider.polylineCoordinates,
                        color: Colors.blue,
                        width: 5),
                  },
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(16.463713, 107.590866), zoom: 14.5),
                  mapType: MapType.terrain,
                  myLocationEnabled: true,
                  markers: Set.from(googleMapProvider.markers),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: InkWell(
                    onTap: () async {
                      // final availableMap =
                      //     await map_launcher.MapLauncher.installedMaps;
                      // await availableMap.first.showDirections(
                      //     destination:
                      //         map_launcher.Coords(16.463713, 107.590866));
                      showModalBottomSheet<void>(
                        context: context,
                        isDismissible: true,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return NavigationMap(placeLocation: LatLng(widget.motel.latitude,widget.motel.longitude));
                        },
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.lightBlueAccent.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 3,
                                offset: const Offset(2, 2))
                          ]),
                      child: const Center(
                        child: Icon(
                          Icons.send_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  Widget bottomBar(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userProvider, child) => Positioned(
        bottom: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              boxShadow: [
                BoxShadow(
                    blurRadius: 3,
                    color: Colors.grey.withOpacity(0.1),
                    offset: const Offset(0, -1))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                        opacity: 0.6,
                        child: Text(
                          S.of(context).boardinghouse_detail_total_price,
                          style: Theme.of(context).textTheme.displaySmall,
                        )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.attach_money_outlined,
                          color: Theme.of(context).iconTheme.color,
                          size: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.motel.adParams['deposit'] == null
                                  ? "0 đ"
                                  : widget.motel.adParams['deposit']['value'],
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Text(
                              '/month',
                              style: Theme.of(context).textTheme.displaySmall,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                widget.motel.hostID ==
                        (userProvider.userCurrent == null
                            ? ""
                            : userProvider.userCurrent!.id)
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          if (userProvider.userCurrent == null) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: const Text(
                                  'Bạn phải đăng nhập để sử dụng chức năng này!'),
                              action: SnackBarAction(
                                label: 'Đăng nhập',
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AuthService().handleAuthState()));
                                },
                              ),
                            );

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RentNowPage(
                                          room: widget.motel,
                                        )));
                          }
                        },
                        child: Container(
                          width: 140,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    color: Colors.grey.withOpacity(0.5),
                                    offset: const Offset(2, 2))
                              ]),
                          child: Center(
                            child: Text(
                              S.of(context).boardinghouse_detail_rent_now,
                              style: GoogleFonts.readexPro(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, List<String> images) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(
                child: Text(
              "Images of Room",
              style: GoogleFonts.readexPro(),
            )),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Stack(children: [
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) => CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg'),
                  ),
                ),
                Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 30,
                          color: Colors.white,
                        )
                      ]),
                )
              ]),
            ));
      },
    );
  }

  Widget review(BuildContext context) {
    return Consumer<RoomModel>(
      builder: (context, roomProvider, child) => FutureBuilder(
        future: roomProvider.getReview(widget.motel.roomId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Review',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 40),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot
                                                .data![index].user.image,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              105,
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  snapshot
                                                      .data![index].user.name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data![index].rating
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displayMedium,
                                                      ),
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.orange,
                                                        size: 20,
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data![index].createdAt
                                                        .toString()
                                                        .split(" ")[0],
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displaySmall,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(snapshot.data![index].comment,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    ...snapshot.data![index].images.map((e) =>
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          width: 100,
                                          height: 100,
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                  e,
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
