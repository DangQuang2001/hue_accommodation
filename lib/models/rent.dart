class Rent {
  String id;
  String dateCreate;
  String hostID;
  String userID;
  String name;
  String image;
  String roomImage;
  String phone;
  String roomID;
  String roomName;
  int numberDaysRented;
  int numberPeople;
  String note;
  int isConfirmed;

  Rent({
    required this.id,
    required this.dateCreate,
    required this.hostID,
    required this.userID,
    required this.name,
    required this.image,
    required this.roomImage,
    required this.phone,
    required this.roomID,
    required this.roomName,
    required this.numberDaysRented,
    required this.numberPeople,
    required this.note,
    required this.isConfirmed,
  });

  factory Rent.fromJson(Map<String, dynamic> json) {
    return Rent(
      id: json['id'],
      dateCreate:json['dateCreate'],
      hostID: json['hostID'],
      userID: json['userID'],
      name: json['name'],
      image: json['image'],
      roomImage: json['roomImage'],
      phone: json['phone'],
      roomID: json['roomID'],
      roomName: json['roomName'],
      numberDaysRented: json['numberDaysRented'],
      numberPeople: json['numberPeople'],
      note: json['note'],
      isConfirmed: json['isConfirmed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateCreate': dateCreate,
    'hostID': hostID,
    'userID': userID,
    'name': name,
    'image':image,
    'roomImage':roomImage,
    'phone': phone,
    'roomID': roomID,
    'roomName': roomName,
    'numberDaysRented': numberDaysRented,
    'numberPeople': numberPeople,
    'note': note,
    'isConfirmed': isConfirmed ,
  };
}