import 'dart:async';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:http/http.dart' as http;

class ChatController {
  late String roomIdReplace;
  late String roomIdReplaceFirst;
  late List listJoinRoom;
  StreamController<Map<String, dynamic>>? _messageController;

  Stream<Map<String, dynamic>> get messages => _messageController!.stream;

  late IO.Socket _socket;

  void initSocket(String roomId, List<String> userId, String userCurrentId,String token) {
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
    });

    _messageController ??= StreamController<Map<String, dynamic>>.broadcast();

    _socket.onConnect((_) {
      print('connect');
      _socket.emit('msg', 'test');
      if (roomId != "") {
        roomIdReplace = roomId;
        roomIdReplaceFirst = roomId;
        _socket.emit('join-room', roomId);
      } else {
        if (userId[0].compareTo(userId[1]) < 0) {
          roomIdReplace="";
          roomIdReplaceFirst = userId[0] + userId[1];
          _socket.emit('join-room', userId[0] + userId[1]);
        } else {
          roomIdReplace="";
          roomIdReplaceFirst = userId[1] + userId[0];
          _socket.emit('join-room', userId[1] + userId[0]);
        }
      }
    });

    _socket.on('disconnect', (_) => print('disconnect: ${_socket.id}'));
    _socket.on('list-user-join-room', (data) {
      listJoinRoom = data as List;
      print(listJoinRoom);
    });

    _socket.on('new-message', (data) {
      if (_messageController!.isClosed) {
        _messageController = StreamController<Map<String, dynamic>>.broadcast();
      }
      final key = encrypt.Key.fromUtf8(
          'my32lengthsupersecretnooneknows1'); //Giải mã mật khẩu
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final encrypted = encrypt.Encrypted.fromBase64(data['content']);
      data['content'] = encrypter.decrypt(encrypted, iv: iv);
      _messageController!.add(data);
      if (roomIdReplace != "") {
        isReadMessage(roomIdReplace, userCurrentId);
      }
      if (listJoinRoom.length == 1) {
        print(token);
        sendNotification(token);
      }
    });

    _socket.connect();
  }

  void sendMessage(String sender, List<String> userId, String content,
      String typeM, bool isNewRoom) {
    //Create RoomChat and ChatDetail by First Message
    final key = encrypt.Key.fromUtf8(
        'my32lengthsupersecretnooneknows1'); //Mã hóa mật khẩu
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(content, iv: iv);
    if (isNewRoom) {
      createRoom(userId, sender, encrypted.base64.trim(), typeM);
      _socket.emit('send-message', {
        'roomId': roomIdReplaceFirst,
        'message': {
          'userId': sender,
          'content': encrypted.base64.trim(),
          'typeM': typeM,
          'createdAt': DateTime.now().toString()
        }
      });
    }
    // Update ChatDetail
    else {
      _socket.emit('send-message', {
        'roomId': roomIdReplaceFirst,
        'message': {
          'userId': sender,
          'content': encrypted.base64.trim(),
          'typeM': typeM,
          'createdAt': DateTime.now().toString()
        }
      });
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
      roomIdReplace = jsonDecode(response.body)['_id'];
    }
    if (response.statusCode == 403) {
      print(response.body);
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

  Future isReadMessage(String roomId, String userId) async {
    await http.post(Uri.parse('$url/api/room-chat/is-read-message'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body:
            jsonEncode(<String, dynamic>{'roomId': roomId, 'userId': userId}));

  }

  Future sendNotification(String token) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAlMIgmY8:APA91bHdzbQRIjbCxEvY6JwJqVIVZrnoM-IrjzKxijhbYPUrea9Weg8A4avDg6llt6IYz-nu-yO2iWIcP9jRq1VK0AH01EcE0Vnlrj3E56SR7qvPYmlOlC85PClgCYqqsDDMqLqZcbDY'
        },
        body: jsonEncode(<String, dynamic>{
          "to":token,
          "data": {"message": "Tin nhan moi!", "type": "notification"}
        }));
  }

  void dispose() {
    _socket.off('connect');
    _socket.off('disconnect');
    _socket.off('new-message');
    _socket.off('from_server');
    _messageController?.close();
    _socket.disconnect();
  }
}
