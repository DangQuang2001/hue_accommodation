import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:hue_accommodation/models/room.dart';
import 'dart:ui' as ui;

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../models/review.dart';
import '../services/provinces_api.dart';
import '../services/room_api.dart';

class RoomProvider extends ChangeNotifier {
  bool isLoadMoreRunning = false;
  bool isLoadMoreRunningFilter = false;
  List<Room> listRoom = [];
  List<Room> listRoomHost = [];
  List<Room> listRemove = [];
  List<Room> listMiniFirstLoad = [];
  List<Room> listMotelFirstLoad = [];
  List<Room> listWholeFirstLoad = [];
  List<Room> listTopRating = [];
  List<Room> listRent = [];
  List<Room> listSearch = [];
  List<Room> listMain = [];
  int typeName = 0;
  int skip = 3;
  int skipFilter = 3;
  int limit = 2;
  int listRemoveLength = 0;
  bool hasNextPage = true;
  bool hasNextPageFilter = true;

  Future<bool> createRoom(
      String hostID,
      String hostName,
      String imageHost,
      String title,
      String description,
      String address,
      double area,
      String furnishing,
      double price,
      String typeRoom,
      List<String> listImageUrl) async {
    final response = await http.post(Uri.parse('$url/api/motelhouse/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "dateCreate": DateTime.now().toString(),
          "hostID": hostID,
          "hostName": "Dang Quang",
          "name": title.toString(),
          "description": description,
          "category": typeRoom == 'Mini House'
              ? [1]
              : typeRoom == 'Motel House'
                  ? [2]
                  : [3],
          "images": listImageUrl,
          "longitude": 1.2,
          "latitude": 1.2,
          "typeName": "Cho thuê",
          "image": listImageUrl[0],
          "rating": 0,
          "hasRoom": true,
          "idReview": 1,
          "adParams": {
            "address": {"id": "address", "value": address, "label": "Địa chỉ"},
            "area": {"id": "area", "value": "Thành phố Huế", "label": "Quận"},
            "deposit": {
              "id": "deposit",
              "value": "$price",
              "label": "Tình trạng nội thất"
            },
            "furnishing_rent": {
              "id": "furnishing_rent",
              "value": "Nội thất cao cấp",
              "label": "Tình trạng nội thất"
            },
            "region": {
              "id": "region",
              "value": "Thừa Thiên Huế",
              "label": "Tỉnh"
            },
            "size": {"id": "size", "value": area, "label": "Diện tích"},
            "ward": {"id": "ward", "value": "", "label": "Phường"}
          },
          "isDelete": false
        }));

    if (response.statusCode == 200) {
      getListRoomHost(hostID);
      await createNotification(
          title, jsonDecode(response.body)['id'], hostID, imageHost, hostName);

      final responses =
          await http.get(Uri.parse('$url/api/fcmtoken/get-list-token-device'));

      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAlMIgmY8:APA91bHdzbQRIjbCxEvY6JwJqVIVZrnoM-IrjzKxijhbYPUrea9Weg8A4avDg6llt6IYz-nu-yO2iWIcP9jRq1VK0AH01EcE0Vnlrj3E56SR7qvPYmlOlC85PClgCYqqsDDMqLqZcbDY'
          },
          body: jsonEncode(<String, dynamic>{
            "registration_ids":
                (jsonDecode(responses.body) as List<dynamic>).toSet().toList(),
            "priority": "high",
            "content_available": true,
            "notification": {
              "badge": 42,
              "title": "Quuang dep trai!",
              "body": "Image"
            },
            "data": {
              "content": {
                "id": 1,
                "badge": 42,
                "channelKey": "alerts",
                "displayOnForeground": true,
                "notificationLayout": "BigPicture",
                "largeIcon": listImageUrl[0],
                "bigPicture": listImageUrl[0],
                "showWhen": true,
                "autoDismissible": true,
                "privacy": "Private",
                "payload": {"secret": "Awesome Notifications Rocks!"}
              },
              "roomID": jsonDecode(response.body)['id'],
              "actionButtons": [
                {"key": "REPLY", "label": "Reply", "requireInputText": true},
                {
                  "key": "DISMISS",
                  "label": "Dismiss",
                  "actionType": "DismissAction",
                  "isDangerousOption": true,
                  "autoDismissible": true
                }
              ],
              "Android": {
                "content": {
                  "title": "$hostName đã mở phòng trọ mới!  😍 ",
                  "payload": {"android": """$title\\n $description """}
                }
              }
            }
          }));
    }
    if (response.statusCode == 403) {
      print('Error: Khong them duoc room');
    }

    return true;
  }

  Future<bool> updateRoom(
      String id,
      String hostID,
      String title,
      String description,
      String address,
      double area,
      String furnishing,
      double price,
      String typeRoom,
      List<String> listImageUrl) async {
    final response = await http.post(Uri.parse('$url/api/motelhouse/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": id,
          "dateCreate": DateTime.now().toString(),
          "hostID": hostID,
          "hostName": "Dang Quang",
          "name": title.toString(),
          "description": description,
          "category": typeRoom == 'Mini House'
              ? [1]
              : typeRoom == 'Motel House'
                  ? [2]
                  : [3],
          "images": listImageUrl,
          "longitude": 1.2,
          "latitude": 1.2,
          "typeName": "Cho thuê",
          "image": listImageUrl[0],
          "rating": 0,
          "hasRoom": true,
          "idReview": 1,
          "adParams": {
            "address": {"id": "address", "value": address, "label": "Địa chỉ"},
            "area": {"id": "area", "value": "Thành phố Huế", "label": "Quận"},
            "deposit": {
              "id": "deposit",
              "value": "$price",
              "label": "Tình trạng nội thất"
            },
            "furnishing_rent": {
              "id": "furnishing_rent",
              "value": "Nội thất cao cấp",
              "label": "Tình trạng nội thất"
            },
            "region": {
              "id": "region",
              "value": "Thừa Thiên Huế",
              "label": "Tỉnh"
            },
            "size": {"id": "size", "value": area, "label": "Diện tích"},
            "ward": {"id": "ward", "value": "", "label": "Phường"}
          },
          "isDelete": false
        }));

    if (response.statusCode == 200) {}
    if (response.statusCode == 403) {
      print('Error: Khong them duoc room');
    }

    return true;
  }

  //Get all MotelRoom
  Future<List<Room>> getAllRoom() async {
    final response = await http.get(Uri.parse('$url/api/motelhouse'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    return listRoom = listObject.map((e) => Room.fromJson(e)).toList();
  }

  Future<List> getListNameRoom() async {
    final response = await http.get(Uri.parse('$url/api/motelhouse'));
    var jsonObject = jsonDecode(response.body);
    return jsonObject;
  }

  //Lazyloading motel house
  Future<void> lazyLoadingMini(
      String searchValue, List<int> category, int skip, int limit) async {
    final response = await http.post(
        Uri.parse('$url/api/motelhouse/lazyloading'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "searchValue": searchValue,
          "category": [1],
          "skip": skip,
          "limit": limit
        }));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listMiniFirstLoad = listObject.map((e) => Room.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> lazyLoadingMotel(
      String searchValue, List<int> category, int skip, int limit) async {
    final response = await http.post(
        Uri.parse('$url/api/motelhouse/lazyloading'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "searchValue": searchValue,
          "category": [2],
          "skip": skip,
          "limit": limit
        }));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listMotelFirstLoad = listObject.map((e) => Room.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> lazyLoadingWhole(
      String searchValue, List<int> category, int skip, int limit) async {
    final response = await http.post(
        Uri.parse('$url/api/motelhouse/lazyloading'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "searchValue": searchValue,
          "category": [3],
          "skip": skip,
          "limit": limit
        }));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listWholeFirstLoad = listObject.map((e) => Room.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getTopRating(int limit) async {
    final response =
        await http.get(Uri.parse('$url/api/motelhouse/top/rating'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listTopRating = listObject.map((e) => Room.fromJson(e)).toList();
    notifyListeners();
  }

  Future<List<Room>> getListRoomHost(String id) async {
    final response = await http.get(Uri.parse('$url/api/motelhouse/$id'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    return listRoomHost = listObject.map((e) => Room.fromJson(e)).toList();
  }

  //Get all List Remove
  Future<List<Room>> getListRemove(String hostID) async {
    final response =
        await http.get(Uri.parse('$url/api/motelhouse/listremove/$hostID'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listRemoveLength = listObject.length;
    notifyListeners();
    return listRemove = listObject.map((e) => Room.fromJson(e)).toList();
  }

  Future<bool> remove(String id) async {
    final response =
        await http.delete(Uri.parse('$url/api/motelhouse/remove/$id'));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> restore(String id) async {
    final response =
        await http.delete(Uri.parse('$url/api/motelhouse/restore/$id'));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<Room> getDetailRoom(String id) async {
    final response =
        await http.get(Uri.parse('$url/api/motelhouse/get-motel-detail/$id'));
    var jsonObject = jsonDecode(response.body) as Map<String, dynamic>;
    return Room.fromJson(jsonObject);
  }

  Future<bool> createNotification(String title, String roomID, String hostID,
      String imageHost, String nameHost) async {
    final response = await http.post(Uri.parse('$url/api/notification/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "title": title,
          "roomID": roomID,
          "hostID": hostID,
          "imageHost": imageHost,
          "nameHost": nameHost,
          "dateSend": DateTime.now().toString(),
          "isDelete": []
        }));

    if (response.statusCode == 200) {}
    if (response.statusCode == 403) {
      print('Error: Khong them duoc Notification');
    }

    return true;
  }

  //Filter room ---------------------------------------------------------------------------------

  Future<void> filterRoom(
      String searchValue, int typeName, int skip, int limit) async {
    final response = await http.post(Uri.parse('$url/api/motelhouse/filter'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "searchValue": searchValue,
          "typeName": typeName,
          "skip": skip,
          "limit": limit
        }));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listRent = listObject.map((e) => Room.fromJson(e)).toList();
    listMain = listRent;
    notifyListeners();
  }

  //Search Room
  Future<void> searchRoom(String searchValue) async {
    final response =
        await http.get(Uri.parse('$url/api/motelhouse/search/$searchValue'));
    var jsonObject = jsonDecode(response.body);
    var listObject = jsonObject as List;
    listSearch = listObject.map((e) => Room.fromJson(e)).toList();
    listMain = listSearch;
    notifyListeners();
  }

Future<bool> deleteRoom(String id)async{
  final response =
      await http.delete(Uri.parse('$url/api/motelhouse/delete/$id'));
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

  getDataFirstTime() async{
    await getTopRating(5);
    await lazyLoadingMotel("", [1, 2, 3], 0, 20);
    await lazyLoadingMini("", [1, 2, 3], 0, 5);
    await lazyLoadingWhole("", [1, 2, 3], 0, 20);
  }

  lazyLoading() async{
    if (isLoadMoreRunning == false &&
        hasNextPage == true) {
      skip += 2;
      (() async {

          isLoadMoreRunning = true;
          notifyListeners();
        final response = await http.post(
            Uri.parse('$url/api/motelhouse/lazyloading'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode(<String, dynamic>{
              "searchValue": "",
              "category": [1],
              "skip": skip,
              "limit": limit
            }));
        var jsonObject = jsonDecode(response.body);

        if (jsonObject.isNotEmpty) {
          var listObject = jsonObject as List;
          List<Room> listLoadMore =
          listObject.map((e) => Room.fromJson(e)).toList();
          listMiniFirstLoad.addAll(listLoadMore);
        } else {
            hasNextPage = false;
            notifyListeners();
        }

          isLoadMoreRunning = false;
          notifyListeners();
      })();
    }
  }

  lazyLoadingFilter(int typeName)async{
    if (isLoadMoreRunningFilter == false &&
        hasNextPageFilter == true) {
      skipFilter += 2;
      (() async {
        isLoadMoreRunningFilter = true;
          notifyListeners();
        final response = await http.post(
            Uri.parse('$url/api/motelhouse/filter'),
            headers: <String, String>{
              'Content-Type':
              'application/json; charset=UTF-8'
            },
            body: jsonEncode(<String, dynamic>{
              "searchValue": "",
              "typeName": typeName,
              "skip": skipFilter,
              "limit": limit
            }));
        var jsonObject = jsonDecode(response.body);

        if (jsonObject.isNotEmpty) {
          var listObject = jsonObject as List;
          List<Room> listLoadMore = listObject
              .map((e) => Room.fromJson(e))
              .toList();
          listRent.addAll(listLoadMore);
        } else {
            hasNextPageFilter = false;
            notifyListeners();
        }
        isLoadMoreRunningFilter = false;
        notifyListeners();


      })();
    }
  }

  Future<void> reviewRoom(String roomId,String userId,double rating,String comment,List<String> images)async{
    await RoomApi.reviewRoom(roomId, userId, rating, comment, images);
  }

  Future<List<Review>> getReview(String roomId)async {
    return await RoomApi.getReview(roomId);
  }

  Future<BitmapDescriptor> getMarkerIconFromUrl(String imageUrl) async {
    final image =
    CachedNetworkImageProvider(imageUrl, maxHeight: 150, maxWidth: 150);
    final completer = Completer<ui.Image>();
    final listener = ImageStreamListener(
            (ImageInfo info, bool _) => completer.complete(info.image));
    final stream = image.resolve(ImageConfiguration.empty);
    stream.addListener(listener);
    final uiImage = await completer.future;
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);
  }

  List<AssetEntity> images = [];
  List<String> listImageUrl = [];
  Future<void> selectImages(BuildContext context) async {
    images = [];
    List<AssetEntity>? result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 10,
          requestType: RequestType.image,
          selectedAssets: [],
        ));
      images = result!;
      notifyListeners();
  }
  Future<void> uploadImages() async {
    listImageUrl = [];
    final storage = FirebaseStorage.instance;
    for (var asset in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = storage.ref().child('roomImage').child(fileName);
      final File? file = await asset.file;
      if (file != null) {
        UploadTask task = reference.putFile(file);
        await task.whenComplete(() => null);
        String imageUrl = await reference.getDownloadURL();
        listImageUrl.add(imageUrl);
        notifyListeners();
        // rest of the code here
      } else {
        // handle error, e.g. file is null
      }
    }
  }

  Future<List> getCity()async{
    return await ProvincesApi.getCity();
  }

}
