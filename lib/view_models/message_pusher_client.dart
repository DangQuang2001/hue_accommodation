import 'dart:async';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:pusher_client/pusher_client.dart';

class ChatController {
  late String roomIdReplace;
  late String roomIdReplaceFirst;
  StreamController<Map<String, dynamic>>? _messageController;

  Stream<Map<String, dynamic>> get messages => _messageController!.stream;
  late PusherClient pusher;
  void initSocket(String roomId, List<String> userId) async {
    _messageController ??= StreamController<Map<String, dynamic>>.broadcast();
    try {
      PusherOptions options = PusherOptions(
        host: url,
        wsPort: 6001,
        encrypted: false,
        auth: PusherAuth(
          '$url/pusher/user-auth',
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      pusher =
          PusherClient('a41b81a5a45ccac88d62', options, autoConnect: false);

// connect at a later time than at instantiation.
      pusher.connect();

      if (roomId != "") {
        roomIdReplace = roomId;
        roomIdReplaceFirst = "private-$roomId";
        pusher.subscribe(roomIdReplaceFirst);
      } else {
        if (userId[0].compareTo(userId[1]) < 0) {
          roomIdReplaceFirst = "private-${userId[0] + userId[1]}";
        } else {
          roomIdReplaceFirst = "private-${userId[1] + userId[0]}";
        }
        pusher.subscribe(roomIdReplaceFirst);
      }
    } catch (e) {
      print("ERROR: $e");
    }
    // if (_messageController!.isClosed) {
    //   _messageController = StreamController<Map<String, dynamic>>.broadcast();
    // }
    // final key = encrypt.Key.fromUtf8(
    //     'my32lengthsupersecretnooneknows1'); //Giải mã mật khẩu
    // final iv = encrypt.IV.fromLength(16);
    // final encrypter = encrypt.Encrypter(encrypt.AES(key));
    //
    // final encrypted = encrypt.Encrypted.fromBase64(data['content']);
    // data['content'] = encrypter.decrypt(encrypted, iv: iv);
    // _messageController!.add(data);
  }

  void sendMessage(String sender, List<String> userId, String content,
      String typeM, bool isNewRoom) async {
    //Create RoomChat and ChatDetail by First Message
    final key = encrypt.Key.fromUtf8(
        'my32lengthsupersecretnooneknows1'); //Mã hóa mật khẩu
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(content, iv: iv);
    if (isNewRoom) {
      createRoom(userId, sender, encrypted.base64.trim(), typeM);
      Map<String, dynamic> messageData = {
        'roomId': roomIdReplaceFirst,
        'message': {
          'userId': sender,
          'content': encrypted.base64.trim(),
          'typeM': typeM,
          'createdAt': DateTime.now().toString()
        }
      };

      String messageString = jsonEncode(messageData);
      // await pusher.trigger(PusherEvent(
      //   channelName: roomIdReplaceFirst,
      //   eventName: 'client-send-message',
      //   data: messageString,
      // ));
    }
    // Update ChatDetail
    else {
      Map<String, dynamic> messageData = {
        'roomId': roomIdReplaceFirst,
        'message': {
          'userId': sender,
          'content': encrypted.base64.trim(),
          'typeM': typeM,
          'createdAt': DateTime.now().toString()
        }
      };

      String messageString = jsonEncode(messageData);
      // await pusher.trigger(PusherEvent(
      //   channelName: roomIdReplaceFirst,
      //   eventName: 'client-send-message',
      //   data: messageString,
      // ));
      addMessage(sender, encrypted.base64.trim(), typeM);
    }
  }

  Future<bool> createRoom(
      List<String> userId, String sender, String content, String typeM) async {
    final response = await http.post(
        Uri.parse('$url/api/room-chat/create-room'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "room": {
            "id": DateTime.now().microsecondsSinceEpoch.toString(),
            "userId": userId
          },
          "message": {
            "userId": sender,
            "content": content,
            "typeM": typeM,
            "createdAt": DateTime.now().toString()
          }
        }));

    if (response.statusCode == 200) {
      roomIdReplace = jsonDecode(response.body)['roomChatId'];
    }
    if (response.statusCode == 403) {
      print('Error: Khong them duoc user');
    }

    return true;
  }

  Future addMessage(String sender, String content, String typeM) async {
    await http.post(Uri.parse('$url/api/room-chat/add-message'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'roomId': roomIdReplace,
          'message': {
            'userId': sender,
            'content': content,
            'typeM': typeM,
            'createdAt': DateTime.now().toString()
          }
        }));
  }

  dynamic onAuthorizer(
      String channelName, String socketId, dynamic options) async {
    final response = await http.post(
      Uri.parse('$url/pusher/user-auth'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'socket_id': socketId,
        'channel_name': channelName,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return {
        "auth": jsonDecode(response.body)['auth'],
        "channel_name": channelName
      };
    } else {
      throw Exception('Failed to authenticate with Pusher: ${response.body}');
    }
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("onSubscriptionSucceeded: $channelName data: $data");
  }

  void onSubscriptionError(String message, dynamic e) {
    print("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    print("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print("onMemberAdded: $channelName member: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print("onMemberRemoved: $channelName member: $member");
  }

  void onError(String message, int? code, dynamic e) {
    print("onError: $message code: $code exception: $e");
  }

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection: $currentState");
  }

  void dispose() async {
    await pusher.unsubscribe(roomIdReplaceFirst);
    await pusher.disconnect();
    _messageController?.close();
  }
}
