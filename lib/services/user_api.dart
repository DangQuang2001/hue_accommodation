import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

import '../models/user.dart';

class UserApi{

  // Update role for account - Host & User
  static Future<User?> updateRole(String email,bool isHost)async{
    final response =  await http.post(Uri.parse('$url/api/user/update-role'),
        headers: <String, String>{
          'Content-Type':
          'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "email":email,
          "isHost":isHost
        }));
    if(response.statusCode == 200){
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // Create account for user
  static Future<bool> createUser(String name, String email, String password,
      String image, String phone, bool isGoogle, bool isHost) async {
    try{
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
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 403) {
        print('Error: Khong them duoc user');
      }
      return true;
    }
    catch(e){
      print('createUser error:$e');
      return false;
    }
    }
    static Future<User?> updateUser(
        String id,
        String name,
        String email,
        String password,
        String image,
        String phone,
        String address,
        bool isGoogle,
        bool isHost) async {
      try{
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
          var jsonObject = jsonDecode(response.body);
          return User.fromJson(jsonObject);
        }
        if (response.statusCode == 403) {
          return null;
        }
      }
      catch(e){
        print('Update user error: $e');
        return null;
      }
      return null;
    }

    // Change avatar user
    static Future<User?> changeAvatar(String email, String image) async {
      try{
        final response = await http.post(Uri.parse('$url/api/user/changeavatar'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(<String, dynamic>{
              "email": email,
              "image": image,
            }));
        if (response.statusCode == 200) {
          var jsonObject = jsonDecode(response.body);
          return User.fromJson(jsonObject);
        }
        if (response.statusCode == 403) {
          return null;
        }
        return null;
      }
      catch(e){
        print('Change avatar error: $e');
        return null;
      }
    }

    //Login
  static Future<User?> login(String email, String password) async {
    final response = await http.post(Uri.parse('$url/api/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, dynamic>{"email": email, "password": password}));
    if (response.statusCode == 200) {
      var jsonObject =await jsonDecode(response.body);
      return User.fromJson(jsonObject['data'][0]);
    }
    if (response.statusCode == 403) {
      return null;
    }
    if (response.statusCode == 404) {
      return null;
    }
    return null;
  }

  //Check email is exist
static Future<User?> checkIsmailGoogle(String mail) async {
  final response =
  await http.get(Uri.parse('$url/api/user/checkemail/$mail'));
  if (response.statusCode == 200) {
    var jsonObject = jsonDecode(response.body);
    return User.fromJson(jsonObject[0]);
  }
  if (response.statusCode == 403) {
    return null;
  }
  return null;
}
}
