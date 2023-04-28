import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:hue_accommodation/services/chat_api.dart';

class ChatProvider extends ChangeNotifier {
  bool isGetChat = false;
  bool isUserOnline1 = false;
  Map<String,dynamic> tokenUser = {};
  int countNewChat = 0;
  late bool isNewRoom;
  late String roomId;
  late List infoUserRoom;
  List<Map<String, dynamic>> listMessage = [];
  List<Map<String, dynamic>> listRoomChat = [];

  Future<bool> checkRoom(List<String> userId) async {
    isNewRoom = true;
    roomId = "";
    infoUserRoom = [];
    final response = await ChatApi.checkRoom(userId);
    if (response.statusCode == 200) {
      isNewRoom = false;
      roomId = jsonDecode(response.body)['_id'].toString();
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
    final messages = await ChatApi.getChatDetail(roomId, skip, limit);
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
    final messages = await ChatApi.checkMessageIsInserted(roomId, skip, limit);
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
    countNewChat = 0;
    final key = encrypt.Key.fromUtf8(
        'my32lengthsupersecretnooneknows1'); //Giải mã mật khẩu
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final data = await ChatApi.getRoomChat(userId);
    listRoomChat = data;
    final decryptedMessages = listRoomChat.map((msg) {
      if (msg['_id']['message'].isNotEmpty) {
        try {
          final encrypted =
              encrypt.Encrypted.fromBase64(msg['_id']['message'][0]['content']);
          final decrypted = encrypter.decrypt(encrypted, iv: iv);
          msg['_id']['message'][0]['content'] = decrypted;
        } catch (e) {
          // Handle decryption errors
        }
      }
      return msg;
    }).toList();
    listRoomChat = decryptedMessages.cast<Map<String, dynamic>>();
    if (countNewChat == 0) {
      for (var element in listRoomChat) {
        if (!(element['_id']['readBy'] as List).contains(userId)) {
          countNewChat = countNewChat + 1;
          notifyListeners();
        }
      }
    }
    listRoomChat.sort((a,b) {
    return DateTime.parse(b['_id']['message'][0]['createdAt']).compareTo(DateTime.parse(a['_id']['message'][0]['createdAt']));
    });
    isGetChat = true;
    notifyListeners();
  }

  Future isReadMessage(String roomId, String userId) async {
    await ChatApi.isReadMessage(roomId, userId);
    getRoomChat(userId);
  }

  Future isOnline(String userId) async {
    final data =await ChatApi.isOnline(userId);
    print(data);
    if (data !=null) {
        isUserOnline1 = true;
        tokenUser = data;
    }
  }


  void disposeChat() {
    listRoomChat = [];
    countNewChat = 0;
    isGetChat = false;
    isUserOnline1 = false;
    tokenUser = {};
    countNewChat = 0;
    listMessage = [];
    notifyListeners();
  }
}
