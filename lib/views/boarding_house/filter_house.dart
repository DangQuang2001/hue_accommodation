import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../generated/l10n.dart';
import '../../view_models/room_view_model.dart';
import 'boarding_house_detail.dart';

class FilterHouse extends StatefulWidget {
  final int typeName;

  const FilterHouse({Key? key, required this.typeName}) : super(key: key);

  @override
  State<FilterHouse> createState() => _FilterHouseState();
}

enum SingingCharacter { newPost, minPrice }

class _FilterHouseState extends State<FilterHouse> {
  bool _isExpanded = false;
  SingingCharacter? _character = SingingCharacter.newPost;
  RangeValues _currentRangeValues = const RangeValues(0, 5000000);
  List<String> listSelected = [];
  bool isLoading = false;



  @override
  void initState() {
    var roomProvider = Provider.of<RoomViewModel>(context, listen: false);
    if (roomProvider.typeName != widget.typeName) {
      isLoading = true;
      roomProvider.typeName = widget.typeName;
      roomProvider.hasNextPageFilter = true;
      roomProvider.isLoadMoreRunningFilter = false;
      roomProvider.skipFilter = 2;
      (() async {
        await roomProvider.filterRoom("", widget.typeName, 0, 5);
        setState(() {
          isLoading = false;
        });
      })();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          appBar(context),
          content(context),
        ],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, roomProvider, child) => Padding(
          padding: const EdgeInsets.only(top: 0),
          child: ExpansionPanelList(
              animationDuration: const Duration(milliseconds: 600),
              children: [
                ExpansionPanel(
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  hasIcon: false,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                _isExpanded = !isExpanded;
                              });
                            },
                            icon: const Icon(
                              Icons.filter_alt_outlined,
                              size: 30,
                            )),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                )),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    roomProvider.searchRoom(value);
                                  } else {
                                    setState(() {
                                      roomProvider.listMain =
                                          roomProvider.listRent;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent)),
                                    focusColor: Colors.transparent,
                                    hintText: 'Search..',
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(0.2),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  body: filter(context),
                  isExpanded: _isExpanded,
                )
              ])),
    );
  }

  Widget content(BuildContext context) {
    return Expanded(
      child: isLoading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator())
          : Consumer<RoomViewModel>(
              builder: (context, roomProvider, child) =>
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo is ScrollEndNotification &&
                          scrollInfo.metrics.extentAfter == 0) {
                       roomProvider.lazyLoadingFilter(widget.typeName);
                      }
                      return true;
                    },
                    child: ListView(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: roomProvider.listMain.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BoardingHouseDetail(
                                                  motel: roomProvider
                                                      .listMain[index]))),
                                  child: SlideInRight(
                                    delay: const Duration(milliseconds: 200),
                                    duration: Duration(
                                        milliseconds: (index + 1) * 100),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      padding: const EdgeInsets.only(
                                          bottom: 10, top: 10),
                                      width: MediaQuery.of(context).size.width,
                                      height: 180,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20),
                                        child: Row(
                                          children: [
                                            Stack(children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Banner(
                                                  textStyle:
                                                      GoogleFonts.readexPro(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 11),
                                                  message: roomProvider
                                                              .listMain[index]
                                                              .hasRoom ==
                                                          true
                                                      ? 'Còn phòng'
                                                      : 'Hết phòng',
                                                  color: roomProvider
                                                              .listMain[index]
                                                              .hasRoom ==
                                                          true
                                                      ? Colors.green
                                                      : Colors.red,
                                                  location:
                                                      BannerLocation.topEnd,
                                                  child: CachedNetworkImage(
                                                    imageUrl: roomProvider
                                                        .listMain[index].image,
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            20,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    fit: BoxFit.cover,
                                                    errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg',fit: BoxFit.cover,)
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
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
                                                          .listMain[index].name,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                          Icons
                                                              .attach_money_outlined,
                                                          color: Colors.orange,
                                                          size: 20,
                                                        ),
                                                        Text(
                                                          roomProvider
                                                                          .listMain[
                                                                              index]
                                                                          .adParams[
                                                                      'deposit'] ==
                                                                  null
                                                              ? "0 đ"
                                                              : roomProvider
                                                                      .listMain[
                                                                          index]
                                                                      .adParams[
                                                                  'deposit']['value'],
                                                          style: GoogleFonts
                                                              .readexPro(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .orangeAccent),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_rounded,
                                                          size: 20,
                                                          color:
                                                              Theme.of(context)
                                                                  .iconTheme
                                                                  .color,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            roomProvider
                                                                    .listMain[index]
                                                                    .adParams[
                                                                'address']['value'],
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displaySmall,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(Icons.description,
                                                            size: 20,
                                                            color: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .color),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            roomProvider
                                                                .listMain[index]
                                                                .description,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
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
                                  ),
                                )),
                        if (roomProvider.isLoadMoreRunningFilter == true)
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xffc8c8c8),
                                highlightColor: const Color(0xff8b8b8b),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          20,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              40,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              60,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              40,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (roomProvider.isLoadMoreRunningFilter == true)
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xffc8c8c8),
                                highlightColor: const Color(0xff8b8b8b),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          20,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 5),
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              40,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              60,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              40,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),
    );
  }

  Widget filter(BuildContext context) {
    double dragDistance = 0.0;
    double minDragDistance = 30.0;
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        dragDistance += details.delta.dy;
        if (-dragDistance > minDragDistance) {
          dragDistance = 0.0;
          setState(() {
            _isExpanded = false;
          });
        }
      },
      child: SizedBox(
        width: double.infinity,
        height: 550,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sort(context),
            const SizedBox(
              height: 20,
            ),
            convenient(context),
            const SizedBox(
              height: 20,
            ),
            price(context),
            const SizedBox(
              height: 20,
            ),
            Consumer<RoomViewModel>(
              builder: (context, roomProvider, child) => GestureDetector(
                onTap: () {
                  if (_character == SingingCharacter.newPost) {
                    setState(() {
                      roomProvider.listMain = roomProvider.listRent;
                      roomProvider.listMain =
                          roomProvider.listMain.where((item) {
                        return _currentRangeValues.start.round() <=
                                double.parse(item.adParams['deposit']
                                        ?['value'] ??
                                    "0") &&
                            double.parse(item.adParams['deposit']?['value'] ??
                                    "0") <=
                                _currentRangeValues.end.round();
                      }).toList();
                      roomProvider.listMain
                          .sort((a, b) => b.createAt.compareTo(a.createAt));
                      _isExpanded = false;
                    });
                  } else {
                    setState(() {
                      roomProvider.listMain = roomProvider.listRent;
                      roomProvider.listMain =
                          roomProvider.listMain.where((item) {
                        return _currentRangeValues.start.round() <=
                                double.parse(item.adParams['deposit']
                                        ?['value'] ??
                                    "0") &&
                            double.parse(item.adParams['deposit']?['value'] ??
                                    "0") <=
                                _currentRangeValues.end.round();
                      }).toList();
                      roomProvider.listMain.sort((a, b) {
                        if (a.adParams['deposit'] == null &&
                            b.adParams['deposit'] == null) {
                          return 0;
                        } else if (a.adParams['deposit'] == null) {
                          return 1;
                        } else if (b.adParams['deposit'] == null) {
                          return -1;
                        } else {
                          return double.parse(a.adParams['deposit']['value'])
                              .compareTo(
                                  double.parse(b.adParams['deposit']['value']));
                        }
                      });
                      _isExpanded = false;
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      S.of(context).boardinghouse_filer_apply,
                      style: GoogleFonts.readexPro(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget sort(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 5),
          child: Text(S.of(context).boardinghouse_filer_sort,
              style: GoogleFonts.readexPro(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 1.5)),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    S.of(context).boardinghouse_filer_new_post,
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Radio<SingingCharacter>(
                activeColor: Colors.blue,
                value: SingingCharacter.newPost,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.attach_money_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    S.of(context).boardinghouse_filer_min_price,
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Radio<SingingCharacter>(
                activeColor: Colors.blue,
                value: SingingCharacter.minPrice,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget convenient(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 5),
          child: Text(S.of(context).boardinghouse_filer_convenient,
              style: GoogleFonts.readexPro(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 1.5)),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.wifi),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    S.of(context).boardinghouse_filer_wifi,
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Checkbox(
                  activeColor: Colors.blue,
                  value: listSelected.contains('wifi'),
                  onChanged: (selected) {
                    _onCategorySelected(selected!, 'wifi');
                  })
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.air_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    S.of(context).boardinghouse_filer_air_condition,
                    style: Theme.of(context).textTheme.displayMedium,
                  )
                ],
              ),
              Checkbox(
                  activeColor: Colors.blue,
                  value: listSelected.contains('air'),
                  onChanged: (selected) {
                    _onCategorySelected(selected!, 'air');
                  })
            ],
          ),
        ),
      ],
    );
  }

  Widget price(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 5),
          child: Text(S.of(context).boardinghouse_filer_price,
              style: GoogleFonts.readexPro(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w200,
                  letterSpacing: 1.5)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${S.of(context).boardinghouse_filer_min}:',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    _currentRangeValues.start.round().toString(),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${S.of(context).boardinghouse_filer_max}:',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    _currentRangeValues.end.round().toString(),
                  )
                ],
              )
            ],
          ),
        ),
        RangeSlider(
          values: _currentRangeValues,
          max: 5000000,
          divisions: 100,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        )
      ],
    );
  }

  void _onCategorySelected(bool selected, String name) {
    if (selected == true) {
      setState(() {
        listSelected.add(name);
      });
    } else {
      setState(() {
        listSelected.remove(name);
      });
    }
  }
}
