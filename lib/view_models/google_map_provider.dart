import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hue_accommodation/models/place_auto_complate_response.dart';

import '../models/autocomplate_prediction.dart';
import '../services/google_map_api.dart';

class GoogleMapProvider extends ChangeNotifier {
  List<AutocompletePrediction> placePredictions = [];
  List<LatLng> polylineCoordinates = [];
  List listPlace = [];

  Future placeAutocomplete(String query) async {
    final response = await GoogleMapApi.placeAutocomplete(query);
    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        placePredictions = result.predictions!;
        notifyListeners();
        getLatLngFromAddress('vietinbank, thừa thiên huế');
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
}
