import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:hue_accommodation/models/post.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PostProvider extends ChangeNotifier {
  List<Post> listAllPost = [];
  List<Post> listRoommate = [];
  List<Post> listTransfer = [];
  List<Post> listOther = [];

  Future<bool> createPost(
      String title,
      String caption,
      String userId,
      String hostName,
      String avatar,
      String? roomId,
      String? roomName,
      int tag,
      List<AssetEntity> listImage) async {
    List<String> listImageUrl = [];
    if (listImage.isNotEmpty) {
      final storage = FirebaseStorage.instance;
      for (var asset in listImage) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference = storage.ref().child('postImages').child(fileName);
        final File? file = await asset.file;
        if (file != null) {
          UploadTask task = reference.putFile(file);
          await task.whenComplete(() => null);
          String imageUrl = await reference.getDownloadURL();
          listImageUrl.add(imageUrl);
          // rest of the code here
        } else {
          // handle error, e.g. file is null
        }
      }
    }

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
          "isHidden": []
        }));

    if (response.statusCode == 200) {
      getPost([tag], userId);
      getPost([0,1,2], userId);
    }
    if (response.statusCode == 403) {
      print(response.body);
    }

    return true;
  }

  Future<void> getPost(List<int> tag, String userId) async {
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
      if(tag[0]==0 && tag.length==1){
        listRoommate = listObject.map((e) => Post.fromJson(e)).toList();
        notifyListeners();
      }
      else if(tag[0]==1){
        listTransfer = listObject.map((e) => Post.fromJson(e)).toList();
        notifyListeners();
      }
      else if(tag[0]==2){
        listOther  = listObject.map((e) => Post.fromJson(e)).toList();
        notifyListeners();
      }
      else{
        listAllPost = listObject.map((e) => Post.fromJson(e)).toList();
        notifyListeners();
      }

    } catch (e) {
      print('Error get post: $e');
    }
  }

  Future<void> likePost(String id, String userId) async {
    try {
      await http.post(Uri.parse('$url/api/post/like-post'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"id": id, "userId": userId}));
      getPost([0,1,2], userId);
    } catch (e) {
      // Handle any exceptions that may be thrown
      print('Error liking post: $e');
    }
  }

  Future<void> dislikePost(String id, String userId) async {
    try {
      await http.post(Uri.parse('$url/api/post/dislike-post'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"id": id, "userId": userId}));
      getPost([0,1,2], userId);
    } catch (e) {
      print('Error dislike post: $e');
    }
  }

  Future<void> hiddenPost(String id, String userId) async {
    try {
      await http.post(Uri.parse('$url/api/post/hidden-post'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, dynamic>{"id": id, "userId": userId}));
      getPost([0,1,2], userId);
      getPost([0], userId);
      getPost([1], userId);
      getPost([2], userId);
    } catch (e) {
      print('Error dislike post: $e');
    }
  }
  Future<void> deletePost(String id, String userId) async {
    try {
      await http.get(Uri.parse('$url/api/post/delete-post/$id'));
      getPost([0,1,2], userId);
      getPost([0], userId);
      getPost([1], userId);
      getPost([2], userId);
    } catch (e) {
      print('Error dislike post: $e');
    }
  }
}
