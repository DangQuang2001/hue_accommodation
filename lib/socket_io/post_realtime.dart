import 'dart:async';
import 'package:hue_accommodation/constants/server_url.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PostController {
  final StreamController<String> _postController =
  StreamController<String>.broadcast();

  Stream<String> get messages => _postController.stream;

  late IO.Socket _socket;

  void initSocket() {
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.onConnect((_) {});
    _socket.on('connect', (_) => print('connect: ${_socket.id}'));
    _socket.on('disconnect', (_) => print('disconnect: ${_socket.id}'));
    _socket.on('from_server', (data) {
      _postController.add(data);
      print(data);
    });
  }

  void createPost(String message) {
    _socket.emit('newPsot', message);

  }

  void dispose() {
    _postController.close();
    _socket.disconnect();
  }
}