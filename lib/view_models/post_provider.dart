import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:hue_accommodation/models/post.dart';
import 'package:hue_accommodation/services/post_api.dart';
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
    final response = await PostApi.createPost(title, caption, userId, hostName, avatar, roomId, roomName, tag, listImage, listImageUrl);
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
      final data = await PostApi.getPost(tag, userId);
      if(tag[0]==0 && tag.length==1){
        listRoommate = data;
        notifyListeners();
      }
      else if(tag[0]==1){
        listTransfer = data;
        notifyListeners();
      }
      else if(tag[0]==2){
        listOther  = data;
        notifyListeners();
      }
      else{
        listAllPost = data;
        notifyListeners();
      }
  }
  Future<List<Post>> getPostById(String userId) async {
      return await PostApi.getPostById(userId);
  }

  Future<void> likePost(String id, String userId) async {
      await PostApi.likePost(id, userId);
      getPost([0,1,2], userId);
  }
  Future<void> dislikePost(String id, String userId) async {
      await PostApi.dislikePost(id, userId);
      getPost([0,1,2], userId);
  }

  Future<void> hiddenPost(String id, String userId) async {
      await PostApi.hiddenPost(id, userId);
      getPost([0,1,2], userId);
      getPost([0], userId);
      getPost([1], userId);
      getPost([2], userId);
  }

  Future<void> hiddenHost(String id, bool isHiddenHost,String userId) async {
      await PostApi.hiddenHost(id, isHiddenHost, userId);
      getPost([0,1,2], userId);
      getPost([0], userId);
      getPost([1], userId);
      getPost([2], userId);
  }

  Future<void> deletePost(String id, String userId) async {
      await PostApi.deletePost(id, userId);
      getPost([0,1,2], userId);
      getPost([0], userId);
      getPost([1], userId);
      getPost([2], userId);
  }
  // Lấy data khi vào diễn đàn
  getAllData(String userId){
    getPost([0, 1, 2], userId);
    getPost([0], userId);
    getPost([1], userId);
    getPost([2], userId);
  }

  List<AssetEntity> images = [];
  Future<void> selectImages(BuildContext context) async {
    images=[];
    List<AssetEntity>? result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.image,
          selectedAssets: [],
        ));
      images = result!;
  }
}
