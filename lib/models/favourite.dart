import 'package:hue_accommodation/models/room.dart';

class Favourite {
  String id;
  Room room;
  String userId;

  Favourite({required this.id, required this.room, required this.userId});
  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      id: json['_id'],
      room: Room.fromJson(json['roomId']),
      userId: json['userId'],
    );
  }
}
