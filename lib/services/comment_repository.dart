import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';

class CommentRepository {
  static Future addComment(
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

  static Future<List<Map<String, dynamic>>?> getComment(String postId, int skip, int limit) async {
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
        return jsonDecode(response.body)['comment'].cast<Map<String, dynamic>>();
      }
      if (response.statusCode == 403) {
        return null;
      }
    } catch (e) {
      print('Error get comment: $e');
      return null;
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>?> getReplyComment(String id, int skip, int limit,List<Map<String, dynamic>> list) async {
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
          return jsonDecode(response.body)['comment'].cast<Map<String, dynamic>>();
        }
        if(jsonDecode(response.body)==null)
        {
          return null;
        }
      }
      if (response.statusCode == 403) {
        return null;
      }
    } catch (e) {
      print('Error get comment: $e');
    }
    return null;
  }

  static Future addReplyComment(
      String commentId, String sender, String content, String typeC) async {
    try {
      await http.post(Uri.parse('$url/api/post-comment/add-reply-comment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            'commentId': commentId,
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

  static Future createReplyComment(
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
}
