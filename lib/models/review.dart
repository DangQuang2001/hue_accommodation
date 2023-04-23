import 'package:hue_accommodation/models/user.dart';

class Review {
  String roomId;
  User user;
  double rating;
  String comment;
  List<String> images;
  DateTime createdAt;

  Review({
    required this.roomId,
    required this.user,
    required this.rating,
    required this.comment,
    required this.images,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      roomId: json['roomId'],
      user: User.fromJson(json['userId']),
      rating: double.parse(json['rating'].toString()),
      comment: json['comment'],
      images: List<String>.from(json['images']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'user': user.toJson(),
      'rating': rating,
      'comment': comment,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}