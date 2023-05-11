import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hue_accommodation/view_models/google_map_view_model.dart';
import 'package:hue_accommodation/view_models/room_view_model.dart';
import 'package:hue_accommodation/views/boarding_house/boarding_house_detail.dart';
import 'package:hue_accommodation/views/components/slide_route.dart';
import 'package:provider/provider.dart';

class NearByLocation extends StatefulWidget {
  const NearByLocation({super.key});

  @override
  State<NearByLocation> createState() => _NearByLocationState();
}

class _NearByLocationState extends State<NearByLocation> {
  int chooseIndex = 1;
  int skip = 0;
  Position? positionPlace;
  String address = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var roomProvider = Provider.of<RoomViewModel>(context, listen: false);
    roomProvider.getListNearbyLimit(null, 5000, 5, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [appBar(context), categories(context), content(context)],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 40.0, right: 20, left: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SlideInRight(
            duration: const Duration(milliseconds: 300),
            child: InkWell(
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
          ),
          SlideInRight(
            duration: const Duration(milliseconds: 400),
            child: Text(
              '     Nearby    ',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }

  Widget categories(BuildContext context) {
    List categories = [
      {"index": 1, "title": "Near me"},
      {"index": 2, "title": "Near School"},
      {"index": 3, "title": "In District"},
    ];
    return Consumer2<RoomViewModel, GoogleMapViewModel>(
      builder: (context, roomProvider, googleMapProvider, child) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...categories.map((e) => GestureDetector(
                    onTap: () async {
                      setState(() {
                        chooseIndex = e['index'];
                        skip = 0;
                      });
                      if (chooseIndex == 1) {
                        // positionPlace = await googleMapProvider
                        //     .getLatLngFromAddress(address);
                        roomProvider.getListNearby(null, 5000, 5, skip);
                      } else if (chooseIndex == 2) {
                        showModalBottomSheet<void>(
                            context: context,
                            isDismissible: true,
                            builder: (BuildContext context) {
                              return chooseSchool(context);
                            });
                      } else if (chooseIndex == 3) {
                        roomProvider.getDistricts(46);
                        showModalBottomSheet<void>(
                            context: context,
                            isDismissible: true,
                            builder: (BuildContext context) {
                              return chooseDistricts(context);
                            });
                      }
                    },
                    child: SlideInRight(
                      duration:  const Duration(milliseconds: 300),
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, top: 0),
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: chooseIndex == e['index']
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 3,
                                  offset: const Offset(2, 3))
                            ]),
                        child: Row(
                          children: [
                            Text(e['title'],
                                style: GoogleFonts.readexPro(
                                    color: chooseIndex == e['index']
                                        ? Colors.white
                                        : Colors.blue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16)),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseDistricts(BuildContext context) {
    return Consumer2<RoomViewModel, GoogleMapViewModel>(
      builder: (context, roomProvider, googleMapProvider, child) =>
          FractionallySizedBox(
        heightFactor: 0.9,
        child: StatefulBuilder(
          builder: (context, setState) => Stack(children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 20,
                          )),
                      Text(
                        'Choose District',
                        style: GoogleFonts.readexPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: roomProvider.listDistrict.isEmpty
                      ? const Text('No room!')
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          itemCount: roomProvider.listDistrict.length,
                          itemBuilder: (context, index) => InkWell(
                                onTap: () async {
                                  positionPlace = await googleMapProvider
                                      .getLatLngFromAddress(roomProvider
                                              .listDistrict[index]['name'] +
                                          ",Tỉnh Thừa Thiên huế");
                                  roomProvider.getListNearbyLimit(
                                      positionPlace, 10000, 5, 0);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              width: 1))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        roomProvider.listDistrict[index]
                                            ['name'],
                                        style:
                                            GoogleFonts.readexPro(fontSize: 17),
                                      ),
                                      roomProvider.listDistrict[index]
                                                  ['name'] ==
                                              roomProvider.listDistrict[index]
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : const Text('')
                                    ],
                                  ),
                                ),
                              )),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget chooseSchool(BuildContext context) {
    List school = [
      {
        "name": "Trường Đại học Sư phạm Huế",
        "address": "34 Lê Lợi, Phú Hội, Thành phố Huế, Thừa Thiên Huế"
      },
      {
        "name": "Trường đại học Kinh tế Huế",
        "address": "99 Hồ Đắc Di, An Cựu, Thành phố Huế, Thừa Thiên Huế"
      },
      {
        "name": "Trường Đại học Y Dược Huế",
        "address": "6 Đ. Ngô Quyền, Vĩnh Ninh, Thành phố Huế, Thừa Thiên Huế"
      },
      {
        "name": "Trường Đại học Khoa học Huế",
        "address": "77 Nguyễn Huệ, Phú Nhuận, Thành phố Huế, Thừa Thiên Huế"
      },
      {
        "name": "Đại học Luật, Đại học Huế",
        "address": "Đường Võ Văn Kiệt, phường An Tây, TP Huế"
      },
      {
        "name": "Trường Đại học Ngoại ngữ Huế",
        "address": "57 Nguyễn Khoa Chiêm, An Cựu, Thành phố Huế, Thừa Thiên Huế"
      },
      {
        "name": "Học viện Âm nhạc Huế",
        "address": "1 Lê Lợi, Vĩnh Ninh, Thành phố Huế, Thừa Thiên Huế"
      },
      {
        "name": "Trường Đại học Nông Lâm Huế",
        "address": "102 Phùng Hưng, Thuận Thành, Thành phố Huế, Thừa Thiên Huế"
      },
      {
        "name": "Đại học Phú Xuân",
        "address":
            "28 Nguyễn Tri Phương, Phú Hội, Thành phố Huế, Thừa Thiên Huế"
      },
    ];

    return Consumer2<RoomViewModel, GoogleMapViewModel>(
      builder: (context, roomProvider, googleMapProvider, child) =>
          FractionallySizedBox(
        heightFactor: 0.9,
        child: StatefulBuilder(
          builder: (context, setState) => Stack(children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 20,
                          )),
                      Text(
                        'Choose School',
                        style: GoogleFonts.readexPro(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      itemCount: school.length,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () async {
                              positionPlace =
                                  await googleMapProvider.getLatLngFromAddress(
                                      school[index]['address']);
                              roomProvider.getListNearbyLimit(
                                  positionPlace, 10000, 5, 0);
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.4),
                                          width: 1))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    school[index]['name'],
                                    style: GoogleFonts.readexPro(fontSize: 17),
                                  ),
                                  school[index]['name'] == school[index][index]
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : const Text('')
                                ],
                              ),
                            ),
                          )),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, roomProvider, child) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: ListView.builder(
            itemCount: roomProvider.listNearbyChoose.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.of(context).push(slideRightToLeft(
                  BoardingHouseDetail(
                      motel: roomProvider.listNearbyChoose[index]))),
              child: SlideInRight(
                duration:   Duration(milliseconds: 100*(index+1)),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 5),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(2, 3))
                      ]),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:
                                    roomProvider.listNearbyChoose[index].image,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  roomProvider.listNearbyChoose[index].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    roomProvider.listNearbyChoose[index]
                                        .adParams['address']['value'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.social_distance_outlined,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${(roomProvider.listNearbyChoose[index].distance! / 1000).toStringAsFixed(2)} km",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
