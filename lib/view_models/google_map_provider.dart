import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_accommodation/models/place_auto_complate_response.dart';

import '../models/autocomplate_prediction.dart';
import '../services/google_map_api.dart';

class GoogleMapProvider extends ChangeNotifier {
  List<AutocompletePrediction> placePredictions = [];
  List<LatLng> polylineCoordinates = [];
  List listPlace = [];
  double distance= 0;
  List<Marker> markers = <Marker>[];

  Future placeAutocomplete(String query) async {
    final response = await GoogleMapApi.placeAutocomplete(query);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        placePredictions = result.predictions!;
        notifyListeners();
      }
    }
  }

  Future searchPlace(String query) async {
    final response =
        await GoogleMapApi.getSearchResultsFromQueryUsingMapbox(query);
  }

  Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations[0].latitude, locations[0].longitude);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void getPolyPoints(LatLng currentUserLocation, LatLng destination) async {
    polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCFMB3KVGNeKYmIgcYh8Wv1At2_wyoTrMU',
      PointLatLng(currentUserLocation.latitude, currentUserLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      polylineCoordinates = polylineCoordinates;
      distance = Geolocator.distanceBetween(
        currentUserLocation.latitude,
        currentUserLocation.longitude,
        destination.latitude,
        destination.longitude,
      );
      notifyListeners();
    }
  }

  Future getPlace(String query) async {
    List<Marker> markers = [];
    final response = await GoogleMapApi.getPlace(query);
    if (response != null) {
      for (var result in response) {
        // Lấy vị trí từ kết quả
        LatLng position = LatLng(
          result["geometry"]["location"]["lat"],
          result["geometry"]["location"]["lng"],
        );

        // Tạo marker từ vị trí
        Marker marker = Marker(
          markerId: MarkerId(result["place_id"]),
          position: position,
          infoWindow: InfoWindow(
            title: result["name"],
            snippet: result["formatted_address"],
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Thêm marker vào Set
        markers.add(marker);
      }
      listPlace = response;
      notifyListeners();
      return markers;
    }
  }

  Future getPlaceNearby(String query,LatLng location) async {
    List<Marker> markers = [];
    final response = await GoogleMapApi.getPlaceNearby(query,location);
    if (response != null) {
      for (var result in response) {
        // Lấy vị trí từ kết quả
        LatLng position = LatLng(
          result["geometry"]["location"]["lat"],
          result["geometry"]["location"]["lng"],
        );

        // Tạo marker từ vị trí
        Marker marker = Marker(
          markerId: MarkerId(result["place_id"]),
          position: position,
          infoWindow: InfoWindow(
            title: result["name"],
            snippet: result["formatted_address"],
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Thêm marker vào Set
        markers.add(marker);
      }
      listPlace = response;
      notifyListeners();
      return markers;
    }
  }



  void directionMap(StreamSubscription<Position> positionStream,Position position,GoogleMapController controller,LatLng destination)async{
    const distanceThreshold = 10; // Khoảng cách tối đa được cho phép tính bằng mét

    double bearing = Geolocator.bearingBetween(position.latitude,
        position.longitude,
        destination.latitude,
        destination.longitude);
      polylineCoordinates.clear();
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing:bearing ,
        tilt: 60,
        target: LatLng(position.latitude,position.longitude),
        zoom: 19.0,
      )));

       distance = Geolocator.distanceBetween(
         position.latitude,
         position.longitude,
        destination.latitude,
        destination.longitude,
      );

       notifyListeners();
      if (distance < distanceThreshold) {
        positionStream.cancel(); // Ngừng lắng nghe sự kiện thay đổi vị trí
      }
      getPolyPoints(LatLng(position.latitude,position.longitude), destination);


  }
  Future setCurrentUserIcon(String url,BitmapDescriptor currentLocationIcon) async {
    await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, url)
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  Future setDestinationIcon(String url,BitmapDescriptor destinationIcon) async {
    await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, url)
        .then((icon) {
      destinationIcon = icon;
    });
  }

  late Position currentLocation;
  void getMarker( Completer<GoogleMapController> controller, LatLng placeLocation)async{
    markers = [];
    BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
    BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((location) async {
      await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, 'assets/images/location2.png')
          .then((icon) {
        currentLocationIcon = icon;
      });
      await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, 'assets/images/home.png')
          .then((icon) {
        destinationIcon = icon;
      });
      currentLocation = location;
      final GoogleMapController controllerMap = await controller.future;
      getPolyPoints(
          LatLng(location.latitude, location.longitude),
          LatLng(
              placeLocation.latitude, placeLocation.longitude));

      markers.add(Marker(
          markerId: const MarkerId('3'),
          icon: destinationIcon,
          position: LatLng(
              placeLocation.latitude, placeLocation.longitude),
          infoWindow: const InfoWindow(title: 'Destination Location')));
      markers.add(Marker(
          markerId: const MarkerId('1'),
          icon: currentLocationIcon,
          position: LatLng(location.latitude, location.longitude),
          infoWindow: const InfoWindow(title: 'My Location')));
      double minLat = min(location.latitude, placeLocation.latitude);
      double maxLat = max(location.latitude, placeLocation.latitude);
      double minLng = min(location.longitude, placeLocation.longitude);
      double maxLng = max(location.longitude, placeLocation.longitude);
      Timer(const Duration(milliseconds: 1000), () async {
        controllerMap.animateCamera(CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(minLat, minLng),
                northeast: LatLng(maxLat, maxLng)),
            30));
      });
     });

}

}
