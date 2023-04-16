import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:http/http.dart' as http;

class CommentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> listComment = [];

  Future addComment(
      String postId, String sender, String content, String typeC) async {
    try {
      await http.post(Uri.parse('$url/api/post-comment/add-comment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'postId': postId,
            'comment': {
              'userId': sender,
              'content': content,
              'typeC': typeC,
              'createdAt': DateTime.now().toString()
            }
          }));
    } catch (e) {
      print('Error add comment: $e');
    }
  }

  Future<void> getComment(String postId, int skip, int limit) async {
    try {
      final response = await http.post(
          Uri.parse('$url/api/post-comment/get-comment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            "postId": postId,
            "skip": skip,
            "limit": limit
          }));

      if (response.statusCode == 200) {
        listComment =
            jsonDecode(response.body)['comment'].cast<Map<String, dynamic>>();
        notifyListeners();
      }
      if (response.statusCode == 403) {}
    } catch (e) {
      print('Error get comment: $e');
    }
  }
}
