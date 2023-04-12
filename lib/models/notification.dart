class Notifications {
  String id;
  String title;
  String roomID;
  String hostID;
  String imageHost;
  String nameHost;
  String dateSend;
  List<dynamic> isDelete;

  Notifications({
    required this.id,
    required this.title,
    required this.roomID,
    required this.hostID,
    required this.imageHost,
    required this.nameHost,
    required this.dateSend,
    required this.isDelete,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      title: json['title'],
      roomID: json['roomID'],
      hostID: json['hostID'],
      imageHost: json['imageHost'],
      nameHost: json['nameHost'],
      dateSend: json['dateSend'] ,
      isDelete: json['isDelete'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['roomID'] = roomID;
    data['hostID'] = hostID;
    data['imageHost'] = imageHost;
    data['nameHost'] = nameHost;
    data['dateSend'] = dateSend;
    data['isDelete'] = isDelete;
    return data;
  }
}