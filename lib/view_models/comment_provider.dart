import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:http/http.dart' as http;

class CommentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> listComment = [];
  List<Map<String, dynamic>> listReply = [];

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
      getComment(postId, 10, 10);
    } catch (e) {
      print('Error add comment: $e');
    }
  }

  Future createReplyComment(
      String commentId, String sender, String content, String typeC) async {
    try {
      await http.post(Uri.parse('$url/api/post-comment/create-reply-comment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'id': commentId,
            'comment': {
              'userId': sender,
              'content': content,
              'typeC': typeC,
              'createdAt': DateTime.now().toString()
            }
          }));

    } catch (e) {
      print('Error reply comment: $e');
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
  Future<void> getReplyComment(String id, int skip, int limit) async {
    listReply = [];
    notifyListeners();
    try {
      final response = await http.post(
          Uri.parse('$url/api/post-comment/get-reply-comment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            "id": id,
            "skip": skip,
            "limit": limit
          }));

      if (response.statusCode == 200) {
        if(jsonDecode(response.body) != null ){
          listReply =
              jsonDecode(response.body)['comment'].cast<Map<String, dynamic>>();
        }
        if(jsonDecode(response.body)==null)
        {

          listReply = [];
        }
        notifyListeners();
      }
      if (response.statusCode == 403) {}
    } catch (e) {
      print('Error get comment: $e');
    }
  }
}
