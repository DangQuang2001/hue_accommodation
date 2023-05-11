import 'package:hue_accommodation/models/room.dart';
import 'package:hue_accommodation/models/user.dart';

class Rent {
  String id;
  String dateCreate;
  User host;
  User user;
  String name;
  String image;
  String roomImage;
  String phone;
  Room room;
  String roomName;
  int numberDaysRented;
  int numberPeople;
  String note;
  int isConfirmed;
  bool isPay;
  List? payment;

  Rent({
    required this.id,
    required this.dateCreate,
    required this.host,
    required this.user,
    required this.name,
    required this.image,
    required this.roomImage,
    required this.phone,
    required this.room,
    required this.roomName,
    required this.numberDaysRented,
    required this.numberPeople,
    required this.note,
    required this.isConfirmed,
    required this.isPay,
    this.payment
  });

  factory Rent.fromJson(Map<String, dynamic> json) {
    return Rent(
      id: json['id'],
      dateCreate:json['dateCreate'],
      host: User.fromJson(json['hostID']),
      user: User.fromJson(json['userID']),
      name: json['name'],
      image: json['image'],
      roomImage: json['roomImage'],
      phone: json['phone'],
      room: Room.fromJson(json['roomID']),
      roomName: json['roomName'],
      numberDaysRented: json['numberDaysRented'],
      numberPeople: json['numberPeople'],
      note: json['note'],
      isConfirmed: json['isConfirmed'],
      isPay:json['isPay'],
      payment:json['paymentId']??[]
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateCreate': dateCreate,
    'hostID': host,
    'userID': user,
    'name': name,
    'image':image,
    'roomImage':roomImage,
    'phone': phone,
    'roomID': room,
    'roomName': roomName,
    'numberDaysRented': numberDaysRented,
    'numberPeople': numberPeople,
    'note': note,
    'isConfirmed': isConfirmed ,
  };
}