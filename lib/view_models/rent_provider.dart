import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:flutter/material.dart';

import '../models/rent.dart';

class RentProvider extends ChangeNotifier {
  bool isRent = false;
  List<Rent> listWaiting = [];
  List<Rent> listConfirm = [];
  List<Rent> listUnConfirm = [];
  List<Rent> listRent = [];
  Future<bool> createRent(
      String hostID,
      String userID,
      String name,
      String image,
      String roomImage,
      String phone,
      String roomID,
      String roomName,
      int numberDaysRented,
      int numberPeople,
      String notes) async {
    final response = await http.post(Uri.parse('$url/api/rent/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "dateCreate": DateTime.now().toString(),
          "hostID": hostID,
          "userID": userID,
          "name": name,
          "image":image,
          "roomImage":roomImage,
          "phone": phone,
          "roomID": roomID,
          "roomName": roomName,
          "numberDaysRented": numberDaysRented,
          "numberPeople": numberPeople,
          "note": notes,
          "isConfirmed": 0,
        }));

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      isRent=true;
      notifyListeners();
    }
    if (response.statusCode == 403) {
      print('Error: Khong them duoc rent');
      isRent =false;
      notifyListeners();
    }

    return true;
  }

  Future<void> getListWaiting(String hostId,int isConfirmed) async {
    final response = await http.get(Uri.parse('$url/api/rent/waiting/$hostId/$isConfirmed'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listWaiting = listObject.map((e) => Rent.fromJson(e)).toList();
    notifyListeners();

  }
  Future<void> getListConfirm(String hostId,int isConfirmed) async {
    final response = await http.get(Uri.parse('$url/api/rent/waiting/$hostId/$isConfirmed'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listConfirm = listObject.map((e) => Rent.fromJson(e)).toList();
    notifyListeners();
    getListWaiting(hostId,0);

  }
  Future<void> getListUnConfirm(String hostId,int isConfirmed) async {
    final response = await http.get(Uri.parse('$url/api/rent/waiting/$hostId/$isConfirmed'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listUnConfirm = listObject.map((e) => Rent.fromJson(e)).toList();
    notifyListeners();
    getListWaiting(hostId,0);

  }
  Future<void> confirm(String hostId,String id) async {
    await http.get(Uri.parse('$url/api/rent/confirm/$id'));
    getListConfirm(hostId, 1);

  }
  Future<void> unConfirm(String hostId,String id) async {
    await http.get(Uri.parse('$url/api/rent/unconfirm/$id'));
    getListUnConfirm(hostId, 2);

  }

  Future<void> getListRent(String userId) async {
    final response = await http.get(Uri.parse('$url/api/rent/rentuser/$userId'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listRent = listObject.map((e) => Rent.fromJson(e)).toList();
    notifyListeners();

  }
}
