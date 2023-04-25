import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_accommodation/view_models/google_map_provider.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;
import 'package:provider/provider.dart';

class ATMPage extends StatefulWidget {
  const ATMPage({super.key});

  @override
  State<ATMPage> createState() => _ATMPageState();
}

class _ATMPageState extends State<ATMPage> {
  int value = 1;
  @override
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();

  // on below line we have specified camera position
  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(16.462766512813303, 107.58981951625772),
    zoom: 14.4746,
  );

  // on below line we have created the list of markers
  late List<Marker> _markers = <Marker>[];
  Location location = Location();

  void setCamera(LatLng location, MarkerId markerId) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: location,
      zoom: 14.4746,
    )));
    controller.showMarkerInfoWindow(markerId);
  }

  @override
  void initState() {
    super.initState();
    var googleMapProvider =
        Provider.of<GoogleMapProvider>(context, listen: false);

    (() async {
      // marker added for hotels location
      // var currentLocation = await location.getLocation();
      // double latitude = double.parse(currentLocation.latitude.toString());
      // double longitude = double.parse(currentLocation.longitude.toString());
      _markers =
          await googleMapProvider.getPlace('ATM Vietinbank,ThuaThienHue');
      // final GoogleMapController controller = await _controller.future;
      setState(() {});
    })();
  }

  @override
  void dispose() {
    // controller.dispose();
    // ignore: avoid_print
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  categories(context),
                  map(context),
                  Expanded(
                      child: SingleChildScrollView(
                    child: listLocation(context),
                  ))
                ],
              ),
            ),
            Positioned(
                child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                        )),
                    Text(
                      "ATM Location",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(
                      width: 30,
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  categories(BuildContext context) {
    return Consumer<GoogleMapProvider>(
      builder: (context, googleMapProvider, child) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  value = 1;
                  FocusScope.of(context).requestFocus(FocusNode());
                  _markers = await googleMapProvider
                      .getPlace('ATM Vietinbank,ThuaThienHue');

                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: value == 1
                          ? Colors.blue
                          : const Color.fromARGB(255, 231, 230, 230),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'VietinBank',
                    style: GoogleFonts.readexPro(
                        color: value == 1
                            ? Colors.white
                            : const Color.fromARGB(255, 75, 75, 75)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  value = 2;
                  FocusScope.of(context).requestFocus(FocusNode());
                  _markers = await googleMapProvider
                      .getPlace('ATM VietComBank,ThuaThienHue');
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: value == 2
                          ? Colors.blue
                          : const Color.fromARGB(255, 231, 230, 230),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'VietComBank',
                    style: GoogleFonts.readexPro(
                        color: value == 2
                            ? Colors.white
                            : const Color.fromARGB(255, 75, 75, 75)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  value = 3;
                  FocusScope.of(context).requestFocus(FocusNode());
                  _markers =
                      await googleMapProvider.getPlace('ATM BIDV,ThuaThienHue');
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: value == 3
                          ? Colors.blue
                          : const Color.fromARGB(255, 231, 230, 230),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'BIDV',
                    style: GoogleFonts.readexPro(
                        color: value == 3
                            ? Colors.white
                            : const Color.fromARGB(255, 75, 75, 75)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  value = 4;
                  FocusScope.of(context).requestFocus(FocusNode());
                  _markers = await googleMapProvider
                      .getPlace('ATM Agribank,ThuaThienHue');
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: value == 4
                          ? Colors.blue
                          : const Color.fromARGB(255, 231, 230, 230),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'AgriBank',
                    style: GoogleFonts.readexPro(
                        color: value == 4
                            ? Colors.white
                            : const Color.fromARGB(255, 75, 75, 75)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  map(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final availableMaps = await map_launcher.MapLauncher.installedMaps;

        await availableMaps.first
            .showDirections(destination: map_launcher.Coords(107, 106));

        /*                          await availableMaps.first.showMarker(
                            coords: map.Coords(widget.model.hotelLocaton!.latitude, widget.model.hotelLocaton!.longitude),
                            title: widget.model.name,
                          );*/
      },
      child: SizedBox(
        height: 350,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          child: Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                // on below line setting camera position
                initialCameraPosition: _kGoogle,
                // on below line we are setting markers on the map
                markers: Set<Marker>.of(_markers),
                // on below line specifying map type.
                mapType: MapType.terrain,
                // on below line setting user location enabled.
                myLocationEnabled: true,
                // on below line setting compass enabled.
                //compassEnabled: true,
                // on below line specifying controller on map complete.
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  listLocation(BuildContext context) {
    return Consumer<GoogleMapProvider>(
      builder: (context, googleMapProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...googleMapProvider.listPlace.map((e) {
            return GestureDetector(
              onTap: () {
                setCamera(
                    LatLng(e['geometry']['location']['lat'],
                        e['geometry']['location']['lng']),
                    MarkerId(e['place_id']));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.4,
                        height: 100,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                e['formatted_address'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ]),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        offset: const Offset(2, 2),
                                        color: Colors.grey.withOpacity(0.1))
                                  ]),
                              child: Transform.rotate(
                                angle: 45,
                                child: const Icon(
                                  Icons.navigation_outlined,
                                  color: Colors.blue,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}