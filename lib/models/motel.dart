import 'package:hue_accommodation/models/info_motel.dart';

class Motel {
  int id;
  String name;
  String image;
  List<String> images;
  double rating;
  double longitude;
  double latitude;
  String address;
  InfoMotel info;
  double cost;
  bool hasRoom;
  int idHost;
  int idReview;
  List<String> timeRent;
  List<String> roomType;
  String roomId;
  Motel(
      {required this.id,
      required this.name,
      required this.image,
      required this.images,
      required this.rating,
      required this.longitude,
      required this.latitude,
      required this.address,
      required this.info,
      required this.cost,
      required this.hasRoom,
      required this.idHost,
      required this.idReview,
      required this.timeRent,
      required this.roomType,
      required this.roomId});

  Motel motelFromJson(Map<String, dynamic> json) {
    return Motel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        images: List<String>.from(json['images']),
        rating: json['rating'].toDouble(),
        longitude: json['longitude'].toDouble(),
        latitude: json['latitude'].toDouble(),
        address: json['address'],
        info: InfoMotel(
          area: json['info']['area'],
          bathRoom: json['info']['bathRoom'],
          bed: json['info']['bed'],
          convenient: List<String>.from(json['info']['convenient']),
          description: json['info']['description'],
        ),
        cost: json['cost'],
        hasRoom: json['hasRoom'],
        idHost: json['idHost'],
        idReview: json['idReview'],
        timeRent: List<String>.from(json['timeRent']),
        roomType: List<String>.from(json['roomType']),
        roomId: json['_id']);
  }
}

// List<Motel> listMotel = [
//   Motel(
//     id: 1,
//     name: 'Century Riverside Hue',
//     image:
//         'https://blog.rever.vn/hubfs/cho_thue_phong_tro_moi_xay_gia_re_ngay_phuong_15_tan_binh3.jpg',
//     images: [],
//     rating: 4.5,
//     longitude: 1,
//     latitude: 1,
//     address: '102 Tuy Lý Vương, Thành phố Huế',
//     info: InfoMotel(
//         area: 120,
//         bathRoom: true,
//         bed: 3,
//         convenient: [],
//         description: 'Xanh sạch đẹp, tiện nghi, điện nước đầy đủ'),
//     cost: 100000,
//     hasRoom: true,
//     idHost: 1,
//     idReview: 1,
//     timeRent: [],
//     roomType: [],
//   ),
//   Motel(
//     id: 2,
//     name: 'Chin Chin',
//     image:
//         'https://pt123.cdn.static123.com/images/thumbs/900x600/fit/2021/11/16/cho-thue-phong-tro-1613975723_1637034014.jpg',
//     images: [],
//     rating: 4.5,
//     longitude: 1,
//     latitude: 1,
//     address: '22 Hùng Vương, Thành phố Huế',
//     info: InfoMotel(
//         area: 120,
//         bathRoom: true,
//         bed: 3,
//         convenient: [],
//         description: 'Xanh sạch đẹp, tiện nghi, điện nước đầy đủ'),
//     cost: 100000,
//     hasRoom: false,
//     idHost: 1,
//     idReview: 1,
//     timeRent: [],
//     roomType: [],
//   ),
//   Motel(
//     id: 3,
//     name: 'Amona Hotel',
//     image:
//         'https://toancanhbatdongsan.com.vn/uploads/images/blog/hoangvy/2022/06/02/cho-thue-phong-tro-1654136735.jpeg',
//     images: [],
//     rating: 4.5,
//     longitude: 1,
//     latitude: 1,
//     address: '280 Trần Phú, Thành phố Huế',
//     info: InfoMotel(
//         area: 120,
//         bathRoom: true,
//         bed: 3,
//         convenient: [],
//         description: 'Xanh sạch đẹp, tiện nghi, điện nước đầy đủ'),
//     cost: 100000,
//     hasRoom: true,
//     idHost: 1,
//     idReview: 1,
//     timeRent: [],
//     roomType: [],
//   ),
//   Motel(
//     id: 4,
//     name: 'Melia Vinpearl Hue',
//     image:
//         'https://trongoixaynha.com/wp-content/uploads/2021/07/xay-phong-tro-gia-bao-nhieu-3.jpg',
//     images: [],
//     rating: 4.5,
//     longitude: 1,
//     latitude: 1,
//     address: 'An Cựu City',
//     info: InfoMotel(
//         area: 120,
//         bathRoom: true,
//         bed: 3,
//         convenient: [],
//         description: 'Xanh sạch đẹp, tiện nghi, điện nước đầy đủ'),
//     cost: 100000,
//     hasRoom: true,
//     idHost: 1,
//     idReview: 1,
//     timeRent: [],
//     roomType: [],
//   ),
//   Motel(
//     id: 5,
//     name: 'Duy Phuoc House',
//     image: 'https://noithatlongthanh.vn/upload1/images/nha-la-viet-nam.jpg',
//     images: [],
//     rating: 4.5,
//     longitude: 1,
//     latitude: 1,
//     address: 'Tuy Lý Vương, Thành phố Huế',
//     info: InfoMotel(
//         area: 120,
//         bathRoom: true,
//         bed: 3,
//         convenient: [],
//         description: 'Xanh sạch đẹp, tiện nghi, điện nước đầy đủ'),
//     cost: 100000,
//     hasRoom: false,
//     idHost: 1,
//     idReview: 1,
//     timeRent: [],
//     roomType: [],
//   ),
// ];
