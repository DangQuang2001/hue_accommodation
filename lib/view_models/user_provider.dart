import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:hue_accommodation/view_models/chat_provider.dart';
import 'package:hue_accommodation/view_models/notification_provider.dart';
import '../models/user.dart';


class UserProvider extends ChangeNotifier {

  User? userCurrent;
  int isLogin = 1;
  bool isUpdate = false;
  bool isUpdateAvatar = false;

  Future<bool> createUser(String name, String email, String password,
      String image, String phone, bool isGoogle, bool isHost) async {
    final response = await http.post(Uri.parse('$url/api/user/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "name": name,
          "email": email,
          "password": password,
          "image": image,
          "phone": phone,
          "address": '',
          "isGoogle": isGoogle,
          "isHost": isHost
        }));

    if (response.statusCode == 200) {}
    if (response.statusCode == 403) {
      print('Error: Khong them duoc user');
    }

    return true;
  }

  Future<bool> updateUser(
      String id,
      String name,
      String email,
      String password,
      String image,
      String phone,
      String address,
      bool isGoogle,
      bool isHost) async {
    final response = await http.post(Uri.parse('$url/api/user/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": id,
          "name": name,
          "email": email,
          "password": password,
          "image": image,
          "phone": phone,
          "address": address,
          "isGoogle": isGoogle,
          "isHost": isHost
        }));

    if (response.statusCode == 200) {
      isUpdate = true;
      notifyListeners();
      var jsonObject = jsonDecode(response.body);
      userCurrent = User(
          id: jsonObject['_id'],
          name: jsonObject['name'],
          email: jsonObject['email'],
          password: jsonObject['password'],
          image: jsonObject['image'],
          phone: jsonObject['phone'],
          address: jsonObject['address'],
          isGoogle: jsonObject['isGoogle'],
          isHost: jsonObject['isHost']);
      notifyListeners();
    }
    if (response.statusCode == 403) {
      isUpdate = false;
      notifyListeners();
    }

    return true;
  }

  Future<bool> changeAvatar(String email, String image) async {
    final response = await http.post(Uri.parse('$url/api/user/changeavatar'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "image": image,
        }));

    if (response.statusCode == 200) {
      isUpdateAvatar = true;
      notifyListeners();
      var jsonObject = jsonDecode(response.body);
      userCurrent = User(
          id: jsonObject['_id'],
          name: jsonObject['name'],
          email: jsonObject['email'],
          password: jsonObject['password'],
          image: jsonObject['image'],
          phone: jsonObject['phone'],
          address: jsonObject['address'],
          isGoogle: jsonObject['isGoogle'],
          isHost: jsonObject['isHost']);
      notifyListeners();
    }
    if (response.statusCode == 403) {
      isUpdateAvatar = false;
      notifyListeners();
    }

    return true;
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(Uri.parse('$url/api/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, dynamic>{"email": email, "password": password}));

    if (response.statusCode == 200) {
      var jsonObject =await jsonDecode(response.body);
      userCurrent = User(
          id: jsonObject['data'][0]['_id'],
          name: jsonObject['data'][0]['name'],
          email: jsonObject['data'][0]['email'],
          password: jsonObject['data'][0]['password'],
          image: jsonObject['data'][0]['image'],
          phone: jsonObject['data'][0]['phone'],
          address: jsonObject['data'][0]['address'],
          isGoogle: jsonObject['data'][0]['isGoogle'],
          isHost: jsonObject['data'][0]['isHost']);

      isLogin = 1;
      notifyListeners();
    }
    if (response.statusCode == 403) {
      isLogin = 2;
      notifyListeners();
    }
    if (response.statusCode == 404) {
      isLogin = 3;
      notifyListeners();
    }

    return true;
  }

  Future<bool> checkIsmail(String mail) async {
    final response =
        await http.get(Uri.parse('$url/api/user/checkemail/$mail'));
    if (response.statusCode == 200) {
      return false;
    }
    if (response.statusCode == 403) {
      return true;
    }
    return false;
  }

  Future<bool> checkIsmailGoogle(String mail) async {
    final response =
        await http.get(Uri.parse('$url/api/user/checkemail/$mail'));
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      userCurrent = User(
          id: jsonObject[0]['_id'],
          name: jsonObject[0]['name'],
          email: jsonObject[0]['email'],
          password: jsonObject[0]['password'],
          image: jsonObject[0]['image'],
          phone: jsonObject[0]['phone'],
          address: jsonObject[0]['address'],
          isGoogle: jsonObject[0]['isGoogle'],
          isHost: jsonObject[0]['isHost']);

      notifyListeners();
      return false;
    }
    if (response.statusCode == 403) {
      await createUser(
          firebase_auth.FirebaseAuth.instance.currentUser!.displayName!,
          firebase_auth.FirebaseAuth.instance.currentUser!.email!,
          "",
          firebase_auth.FirebaseAuth.instance.currentUser!.photoURL!,
          "",
          true,
          true);
      return true;
    }
    return false;
  }
}
