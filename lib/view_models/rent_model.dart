import 'package:flutter/material.dart';
import 'package:hue_accommodation/services/rent_repository.dart';

import '../models/rent.dart';

class RentModel extends ChangeNotifier {
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
    final response = await RentRepository.createRent(
        hostID,
        userID,
        name,
        image,
        roomImage,
        phone,
        roomID,
        roomName,
        numberDaysRented,
        numberPeople,
        notes);
    if (response) {
      isRent = true;
      notifyListeners();
    } else {
      isRent = false;
      notifyListeners();
    }
    return true;
  }

  Future<void> getListWaiting(String hostId, int isConfirmed) async {
    final data = await RentRepository.getListWaiting(hostId, isConfirmed);
    listWaiting = data;
    notifyListeners();
  }

  Future<void> getListConfirm(String hostId, int isConfirmed) async {
    final data = await RentRepository.getListConfirm(hostId, isConfirmed);
    listConfirm = data;
    notifyListeners();
    getListWaiting(hostId, 0);
  }

  Future<void> getListUnConfirm(String hostId, int isConfirmed) async {
    final data = await RentRepository.getListUnConfirm(hostId, isConfirmed);
    listUnConfirm = data;
    notifyListeners();
    getListWaiting(hostId, 0);
  }

  Future<void> confirm(String hostId, String id) async {
    await RentRepository.confirm(hostId, id);
    getListConfirm(hostId, 1);
  }

  Future<void> unConfirm(String hostId, String id) async {
    await RentRepository.unConfirm(hostId, id);
    getListUnConfirm(hostId, 2);
  }

  Future<void> getListRent(String userId) async {
    final data = await RentRepository.getListRent(userId);
    listRent = data;
    notifyListeners();
  }
}
