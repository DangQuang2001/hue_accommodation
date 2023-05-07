import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hue_accommodation/services/chat_repository.dart';
import 'package:hue_accommodation/services/user_repository.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ChatModel extends ChangeNotifier {
  bool isGetChat = false;
  bool isUserOnline1 = false;
  Map<String, dynamic> tokenUser = {};
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
    final data = await ChatRepository.checkRoom(userId);
    if (data!=null) {
      isNewRoom = false;
      roomId = data['_id'].toString();
      infoUserRoom = data['userId'];
      return false;
    }
    else {
      isNewRoom = true;
      final responses = await UserRepository.getUser(userId[1]);
      infoUserRoom = [
        jsonDecode(responses.body),
        {"_id": userId[0]}
      ];
      return false;
    }

  }

  Future<List<Map<String, dynamic>>> getChatDetail(
      String roomId, int skip, int limit) async {
    final key = encrypt.Key.fromUtf8(
        'my32lengthsupersecretnooneknows1'); //Giải mã mật khẩu
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final messages = await ChatRepository.getChatDetail(roomId, skip, limit);
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
    final messages = await ChatRepository.checkMessageIsInserted(roomId, skip, limit);
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
    final data = await ChatRepository.getRoomChat(userId);
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
    listRoomChat.sort((a, b) {
      return DateTime.parse(b['_id']['message'][0]['createdAt'])
          .compareTo(DateTime.parse(a['_id']['message'][0]['createdAt']));
    });
    isGetChat = true;
    notifyListeners();
  }

  Future isReadMessage(String roomId, String userId) async {
    await ChatRepository.isReadMessage(roomId, userId);
    getRoomChat(userId);
  }

  Future isOnline(String userId) async {
    final data = await ChatRepository.isOnline(userId);
    print(data);
    if (data != null) {
      isUserOnline1 = true;
      tokenUser = data;
    }
  }

  Future<String> uploadImages(List<AssetEntity> images) async {
    List<String> listUrl = [];
    final storage = FirebaseStorage.instance;
    for (var asset in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('chatImage').child(fileName);
      final File? file = await asset.file;
      if (file != null) {
        UploadTask task = reference.putFile(file);
        await task.whenComplete(() => null);
        String imageUrl = await reference.getDownloadURL();
        listUrl.add(imageUrl);
      } else {
        // handle error, e.g. file is null
      }
    }
    return listUrl[0];
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
