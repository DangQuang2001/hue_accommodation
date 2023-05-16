import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../view_models/google_map_view_model.dart';

class NavigationMap extends StatefulWidget {
  final LatLng placeLocation;

  const NavigationMap({Key? key, required this.placeLocation})
      : super(key: key);

  @override
  State<NavigationMap> createState() => _NavigationMapState();
}

class _NavigationMapState extends State<NavigationMap> {
  final Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<Position>? positionStream;
  int actionDirection =1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var googleMapProvider =
        Provider.of<GoogleMapViewModel>(context, listen: false);
    googleMapProvider.getMarker(_controller, widget.placeLocation);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        if(positionStream!=null){
          positionStream!.cancel();
        }
        return true;
      },
      child: Consumer<GoogleMapViewModel>(
        builder: (context, googleMapProvider, child) => Container(
          color: Theme.of(context).colorScheme.background,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50), topRight: Radius.circular(50)),
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
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  markers: Set.from(googleMapProvider.markers),
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
            Positioned(
                top: 50,
                left: 30,
                right: 30,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: const Offset(3, 4),
                            color: Colors.grey.withOpacity(0.3))
                      ]),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Icon(Icons.social_distance),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Distance:',
                        style: GoogleFonts.readexPro(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${googleMapProvider.distance.toStringAsFixed(0)} m",
                        style: GoogleFonts.readexPro(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )),
            Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              if(positionStream!=null){
                                positionStream!.cancel();
                              }
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder()),
                            child: Text(
                              "Back",
                              style: GoogleFonts.readexPro(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              positionStream!.pause();
                              setState(() {
                                actionDirection =3;
                              });
                              _controller.future.then((value) =>
                                  value.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                    target: LatLng(widget.placeLocation.latitude,
                                        widget.placeLocation.longitude),
                                    zoom: 19.0,
                                  ))));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: const StadiumBorder()),
                            child: const Icon(Icons.house_outlined)),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              positionStream!.pause();
                              setState(() {
                                actionDirection =3;
                              });
                              _controller.future.then((value) =>
                                  value.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                    target: LatLng(googleMapProvider.currentLocation.latitude,
                                        googleMapProvider.currentLocation.longitude),
                                    zoom: 19.0,
                                  ))));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: const StadiumBorder()),
                            child: const Icon(Icons.person_outline_outlined)),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            width:actionDirection == 3?170 :110,
                            height: 40,
                            child: ElevatedButton.icon(
                                icon: const Icon(Icons.subdirectory_arrow_right),
                                onPressed: () async {
                                  if(actionDirection ==1 ){
                                    setState(() {
                                      actionDirection = 2;
                                    });
                                    GoogleMapController controller =
                                    await _controller.future;
                                    positionStream = Geolocator.getPositionStream(
                                      locationSettings: const LocationSettings(
                                        accuracy: LocationAccuracy.high,
                                        distanceFilter: 0,
                                      ),
                                    ).listen((Position position) {
                                      print('dachay');
                                      googleMapProvider.directionMap(
                                          positionStream!,
                                          position,
                                          controller,
                                          LatLng(widget.placeLocation.latitude,
                                              widget.placeLocation.longitude));
                                    });

                                  }
                                  else if(actionDirection == 2){
                                    positionStream!.pause();
                                    setState(() {
                                      actionDirection =3;
                                    });
                                  }
                                  else{
                                    positionStream!.resume();
                                    setState(() {
                                      actionDirection =2;
                                    });
                                  }

                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder()),
                                label: Text(
                                  actionDirection==1?"Go!":actionDirection==2?"Stop":"Continue",
                                  style: GoogleFonts.readexPro(
                                      fontSize: 20, fontWeight: FontWeight.w400),
                                ))),
                      ],
                    ),
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
