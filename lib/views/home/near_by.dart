import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../constants/route_name.dart';
import '../../generated/l10n.dart';
import '../../view_models/room_view_model.dart';
import '../boarding_house/boarding_house_detail.dart';
import '../components/slide_route.dart';

class NearBy extends StatefulWidget {
  const NearBy({super.key});

  @override
  State<NearBy> createState() => _NearByState();
}

class _NearByState extends State<NearBy> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var roomProvider = Provider.of<RoomViewModel>(context, listen: false);
    roomProvider.getListNearby(null, 5000, 5, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, roomProvider, child) => roomProvider.listNearby.isEmpty
          ? const Text('')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, bottom: 0, top: 30, right: 20),
                  child: SlideInRight(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SlideInRight(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            S.of(context).home_page_nearby,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ),SlideInRight(
                          duration: const Duration(milliseconds: 450),
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RouteName.nearby);
                              },
                              child: Text(
                                S.of(context).home_page_see_all,
                                style: GoogleFonts.readexPro(
                                    fontSize: 15, color: Colors.blue),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      ...roomProvider.listNearby.map((e) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              slideRightToLeft(BoardingHouseDetail(motel: e))),
                          child: SlideInRight(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(right: 10),
                              width: 230,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
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
                                        height: 140,
                                        fit: BoxFit.cover,

                                          errorWidget:(context, url, error) => Image.asset('assets/images/placeholderImage.jpg'),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Container(
                                        width: 70,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                Colors.grey.withOpacity(0.8)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.yellow,
                                              size: 17,
                                            ),
                                            Text(
                                              "${(e.distance! / 1000).toStringAsFixed(2)} km",
                                              style: GoogleFonts.readexPro(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
