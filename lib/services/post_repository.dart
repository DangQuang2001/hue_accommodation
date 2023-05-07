import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../models/post.dart';

class PostRepository{
  static Future createPost(
      String title,
      String caption,
      String userId,
      String hostName,
      String avatar,
      String? roomId,
      String? roomName,
      int tag,
      List<AssetEntity> listImage,List<String> listImageUrl) async {
    final response = await http.post(Uri.parse('$url/api/post/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "title": title,
          "caption": caption,
          "userId": userId,
          "hostName": hostName,
          "avatar": avatar,
          "likesCount": 0,
          "commentsCount": 0,
          "roomId": roomId ?? "",
          "roomName": roomName ?? "",
          "tag": tag,
          "imageUrls": listImageUrl,
          "likedBy": [],
          "isHidden": [],
          "isHiddenHost":false
        }));
    return response;
  }

  static Future getPost(List<int> tag, String userId) async {
    try {
      final response = await http.post(
          Uri.parse('$url/api/post/get-all-post-by-tag'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{
            "tag": tag,
            "isHidden": userId,
          }));
      var jsonObject = jsonDecode(response.body);
      var listObject = jsonObject as List;
      return listObject.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      print('Error get post: $e');
    }
  }

  static Future<List<Post>> getPostById(String userId) async {
    try {
      final response = await http.get(
          Uri.parse('$url/api/post/get-post-by-userId/$userId'));
      var jsonObject = jsonDecode(response.body);
      var listObject = jsonObject as List;
      return listObject.map((e) => Post.fromJson(e)).toList();
    } catch (e) {
      print('Error get post: $e');
      return [];
    }
  }

  static Future<void> likePost(String id, String userId) async {
    try {
      await http.post(Uri.parse('$url/api/post/like-post'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"id": id, "userId": userId}));
    } catch (e) {
      // Handle any exceptions that may be thrown
      print('Error liking post: $e');
    }
  }

  static Future<void> dislikePost(String id, String userId) async {
    try {
      await http.post(Uri.parse('$url/api/post/dislike-post'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"id": id, "userId": userId}));
    } catch (e) {
      print('Error dislike post: $e');
    }
  }

  static Future<void> hiddenPost(String id, String userId) async {
    try {
      await http.post(Uri.parse('$url/api/post/hidden-post'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"id": id, "userId": userId}));
    } catch (e) {
      print('Error dislike post: $e');
    }
  }

  static Future<void> hiddenHost(String id, bool isHiddenHost,String userId) async {
    try {
      await http.post(Uri.parse('$url/api/post/hidden-post-by-host'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"id": id, "isHiddenHost": isHiddenHost}));
    } catch (e) {
      print('Error dislike post: $e');
    }
  }

  static Future<void> deletePost(String id, String userId) async {
    try {
      await http.get(Uri.parse('$url/api/post/delete-post/$id'));
    } catch (e) {
      print('Error dislike post: $e');
    }
  }
}