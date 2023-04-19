class Room {
  String id;
  String dateCreate;
  String hostID;
  String hostName;
  String name;
  String description;
  List<int> category;
  List<String> images;
  double longitude;
  double latitude;
  String typeName;
  String image;
  double rating;
  bool hasRoom;
  int idReview;
  Map<String, dynamic> adParams;
  bool isDelete;
  DateTime createAt;
  String roomId;

  Room(
      {required this.id,
      required this.dateCreate,
      required this.hostID,
      required this.hostName,
      required this.name,
      required this.description,
      required this.category,
      required this.images,
      required this.longitude,
      required this.latitude,
      required this.typeName,
      required this.image,
      required this.rating,
      required this.hasRoom,
      required this.idReview,
      required this.adParams,
      required this.isDelete,
      required this.createAt,
      required this.roomId});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
        id: json['id'],
        dateCreate: json['dateCreate'],
        hostID: json['hostID'].toString(),
        hostName: json['hostName'],
        name: json['name'],
        description: json['description'],
        category: List<int>.from(json['category']),
        images: List<String>.from(json['images']),
        longitude: json['longitude'],
        latitude: json['latitude'],
        typeName: json['typeName'],
        image: json['image'],
        rating: double.parse(json['rating'].toString()),
        hasRoom: json['hasRoom'],
        idReview: json['idReview'],
        adParams: Map<String, dynamic>.from(json['adParams']),
        isDelete: json['isDelete'],
        createAt: DateTime.parse(json['createdAt']),
        roomId: json['_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateCreate': dateCreate,
      'hostID': hostID,
      'hostName': hostName,
      'name': name,
      'description': description,
      'category': category,
      'images': images,
      'longitude': longitude,
      'latitude': latitude,
      'typeName': typeName,
      'image': image,
      'rating': rating,
      'hasRoom': hasRoom,
      'idReview': idReview,
      'adParams': adParams,
      'isDelete': isDelete,
    };
  }
}

List<String> imageList = [
  'https://blogcdn.muaban.net/wp-content/uploads/2022/12/26172116/thiet-ke-phong-tro-30m2.jpg',
  'https://mogi.vn/news/wp-content/uploads/2022/04/phong-tro-gac-lung-dep.jpg',
  'https://blogcdn.muaban.net/wp-content/uploads/2022/12/26172116/thiet-ke-phong-tro-30m2.jpg',
];
