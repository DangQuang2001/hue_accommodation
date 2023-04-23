import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

class ChatApi{
  static Future<http.Response> checkRoom(List<String> userId) async {
    final response = await http.post(Uri.parse('$url/api/room-chat/check-room'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "userId": userId,
        }));
    return response;
  }

  static   Future<List<Map<String, dynamic>>> getChatDetail(
      String roomId, int skip, int limit) async {
    final response = await http.post(
        Uri.parse('$url/api/room-chat/get-chat-detail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, dynamic>{"roomId": roomId, "skip": skip, "limit": limit}));

    return jsonDecode(response.body)[0]['message'].cast<Map<String, dynamic>>();
  }

  static   Future checkMessageIsInserted(String roomId, int skip, int limit) async {
    final response = await http.post(
        Uri.parse('$url/api/room-chat/get-chat-detail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
            <String, dynamic>{"roomId": roomId, "skip": skip, "limit": limit}));
    return jsonDecode(response.body)[0]['message'].cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> getRoomChat(String userId) async {
    try{
      final response =
      await http.get(Uri.parse('$url/api/room-chat/get-room-chat/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body).cast<Map<String, dynamic>>();
      }
      return [];
    } catch (error) {
      print(error);
    }
    return [];
  }

  static Future isReadMessage(String roomId, String userId) async {
    await http.post(Uri.parse('$url/api/room-chat/is-read-message'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body:
        jsonEncode(<String, dynamic>{'roomId': roomId, 'userId': userId}));
  }

  static Future<List> isOnline(String userId) async {
    final response = await http
        .get(Uri.parse('$url/api/fcmtoken/get-list-token-user/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    }
    return [];
  }
}