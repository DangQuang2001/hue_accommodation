import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hue_accommodation/constants/server_url.dart';

class ChatProvider extends ChangeNotifier {
  bool isGetChat = false;
  late bool isNewRoom;
  late String roomId;
  late List infoUserRoom;
  List<Map<String, dynamic>> listMessage = [];
  List<Map<String, dynamic>> listRoomChat = [];

  Future<bool> checkRoom(List<String> userId) async {
    isNewRoom = true;
    roomId = "";
    infoUserRoom = [];
    final response = await http.post(Uri.parse('$url/api/room-chat/check-room'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "userId": userId,
        }));
    if (response.statusCode == 200) {
      isNewRoom = false;
      roomId = jsonDecode(response.body)['id'].toString();
      infoUserRoom = jsonDecode(response.body)['userId'];
      return false;
    }
    if (response.statusCode == 201) {
      isNewRoom = true;
      final responses = await http
          .get(Uri.parse('$url/api/user/get-user-detail/${userId[1]}'));
      infoUserRoom = [
        jsonDecode(responses.body),
        {"_id": userId[0]}
      ];
      return false;
    }
    if (response.statusCode == 403) {
      return true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getChatDetail(
      String roomId, int skip, int limit) async {
    final key = encrypt.Key.fromUtf8(
        'my32lengthsupersecretnooneknows1'); //Giải mã mật khẩu
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final response = await http.post(
        Uri.parse('$url/api/room-chat/get-chat-detail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, dynamic>{"roomId": roomId, "skip": skip, "limit": limit}));
    final messages =
        jsonDecode(response.body)[0]['message'].cast<Map<String, dynamic>>();

    final decryptedMessages = messages.map((msg) {
      if (msg['content'] is String && msg['content'].isNotEmpty) {
        try {
          final encrypted = encrypt.Encrypted.fromBase64(msg['content']);
          final decrypted = encrypter.decrypt(encrypted, iv: iv);
          msg['content'] = decrypted;
        } catch (e) {
          // Handle decryption errors
        }
      }
      return msg;
    }).toList();
    listMessage = decryptedMessages.cast<Map<String, dynamic>>();
    notifyListeners();
    return decryptedMessages.cast<Map<String, dynamic>>();
  }

  Future checkMessageIsInserted(String roomId, int skip, int limit) async {
    final key = encrypt.Key.fromUtf8(
        'my32lengthsupersecretnooneknows1'); //Giải mã mật khẩu
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final response = await http.post(
        Uri.parse('$url/api/room-chat/get-chat-detail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, dynamic>{"roomId": roomId, "skip": skip, "limit": limit}));
    final messages =
        jsonDecode(response.body)[0]['message'].cast<Map<String, dynamic>>();

    final decryptedMessages = messages.map((msg) {
      if (msg['content'] is String && msg['content'].isNotEmpty) {
        try {
          final encrypted = encrypt.Encrypted.fromBase64(msg['content']);
          final decrypted = encrypter.decrypt(encrypted, iv: iv);
          msg['content'] = decrypted;
        } catch (e) {
          // Handle decryption errors
        }
      }
      return msg;
    }).toList();
    listMessage = decryptedMessages.cast<Map<String, dynamic>>();
    notifyListeners();
  }

  Future getRoomChat(String userId) async {
    try {
      final response =
          await http.get(Uri.parse('$url/api/room-chat/get-room-chat/$userId'));
      if (response.statusCode == 200) {
        listRoomChat = jsonDecode(response.body).cast<Map<String, dynamic>>();
        notifyListeners();
        isGetChat = true;
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }
}
