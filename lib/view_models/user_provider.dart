import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import '../models/user.dart';
import '../services/user_api.dart';


class UserProvider extends ChangeNotifier {

  User? userCurrent;
  int isLogin = 1;
  bool isUpdate = false;
  bool isUpdateAvatar = false;

  Future<bool> createUser(String name, String email, String password,
      String image, String phone, bool isGoogle, bool isHost) async {
    return UserApi.createUser(name, email, password, image, phone, isGoogle, isHost);
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
    final data =await UserApi.updateUser(id, name, email, password, image, phone, address, isGoogle, isHost);
    if (data!= null) {
      isUpdate = true;
      notifyListeners();
      userCurrent = data;
    }
    else {
      isUpdate = false;
      notifyListeners();
    }
    return true;
  }

  Future<void> updateRole(String email,bool isHost)async{
    final data= await UserApi.updateRole(email, isHost);
    if(data != null){
      userCurrent =data;
      notifyListeners();
    }
  }

  Future<bool> changeAvatar(String email, String image) async {
    final data = await UserApi.changeAvatar(email, image);
    if (data != null) {
      isUpdateAvatar = true;
      userCurrent = data;
      notifyListeners();
    }
    else {
      isUpdateAvatar = false;
      notifyListeners();
    }
    return true;
  }

  Future<bool> login(String email, String password) async {
   final data = await UserApi.login(email, password);
    if (data != null) {
     userCurrent = data;
      isLogin = 1;
      notifyListeners();
    }
    else{
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

  Future<bool> checkIsmailGoogle(String mail) async {
    final data = await UserApi.checkIsmailGoogle(mail);
    if (data != null) {
      userCurrent = data;
      notifyListeners();
      return false;
    }
    else {
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
