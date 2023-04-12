class Room {
  final String id;
  final String dateCreate;
  final String hostID;
  final String hostName;
  final String name;
  final String description;
  final List<int> category;
  final List<String> images;
  final double longitude;
  final double latitude;
  final String typeName;
  final String image;
  final double rating;
  final bool hasRoom;
  final int idReview;
  final Map<String, dynamic> adParams;
  final bool isDelete;
  final DateTime createAt;

  Room({
    required this.id,
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
    required this.createAt

  });

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
      createAt: DateTime.parse(json['createdAt'])
    );
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
