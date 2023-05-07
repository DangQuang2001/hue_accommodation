import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/user_repository.dart';

class UserModel extends ChangeNotifier {
  User? userCurrent;
  int isLogin = 1;
  bool isUpdate = false;
  bool isUpdateAvatar = false;
  bool isNewAccount = false;

  Future<void> createUser(String name, String email, String password,
      String image, String phone, bool isGoogle, bool isHost) async {
    final data = await UserRepository.createUser(
        name, email, password, image, phone, isGoogle, isHost);
    userCurrent = data;
    notifyListeners();
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
    final data = await UserRepository.updateUser(
        id, name, email, password, image, phone, address, isGoogle, isHost);
    if (data != null) {
      isUpdate = true;
      userCurrent = data;
      notifyListeners();
    } else {
      isUpdate = false;
      notifyListeners();
    }
    return true;
  }

  Future<void> updateRole(String email, bool isHost) async {
    final data = await UserRepository.updateRole(email, isHost);
    if (data != null) {
      userCurrent = data;
      notifyListeners();
    }
  }

  Future<bool> changeAvatar(String email, String image) async {
    final data = await UserRepository.changeAvatar(email, image);
    if (data != null) {
      isUpdateAvatar = true;
      userCurrent = data;
      notifyListeners();
    } else {
      isUpdateAvatar = false;
      notifyListeners();
    }
    return true;
  }

  Future<bool> login(String email, String password) async {
    final data = await UserRepository.login(email, password);
    if (data != null) {
      userCurrent = data;
      isLogin = 1;
      notifyListeners();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> user = userCurrent!.toJson();
      await prefs.setString('user', jsonEncode(user));

    } else {
      isLogin = 2;
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

  Future<bool> checkIsmailGoogle(
      String mail, String name, String photoURL) async {
    final data = await UserRepository.checkIsmailGoogle(mail);
    if (data != null) {
      isNewAccount = false;
      userCurrent = data;
      notifyListeners();
      return false;
    } else {
      isNewAccount = true;
      notifyListeners();
      await createUser(name, mail, "", photoURL, "", true, true);
      return true;
    }
    return false;
  }
  void checkSharedPreference()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('user');
    if(userPref!=null){
      await prefs.remove('user');
    }
  }

  void disposeUser() {
    userCurrent = null;
    checkSharedPreference();
    notifyListeners();
  }
}
