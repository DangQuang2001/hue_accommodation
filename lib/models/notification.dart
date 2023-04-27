import 'package:hue_accommodation/models/user.dart';

class Notifications {
  String id;
  User sender;
  String title;
  int type;
  DateTime dateSend;
  String receivedId;
  List<String> readBy;
  List<String> isDelete;
  String dataId;

  Notifications(
      {required this.id,
      required this.sender,
      required this.title,
      required this.type,
      required this.dateSend,
      required this.receivedId,
      required this.readBy,
      required this.isDelete,
      required this.dataId});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
        id: json['id'],
        sender: User.fromJson(json['senderId']),
        title: json['title'],
        type: json['type'],
        dateSend: json['dateSend'],
        receivedId: json['receivedId'],
        readBy: json['readBy'],
        isDelete: json['isDelete'],
        dataId: json['dataId']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['senderId'] = sender;
    data['title'] = title;
    data['type'] = type;
    data['dateSend'] = dateSend;
    data['receivedId'] = receivedId;
    data['readBy'] = readBy;
    data['isDelete'] = isDelete;
    data['dataId'] = dataId;
    return data;
  }
}
