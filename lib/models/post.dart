class Post {
  String id;
  String? caption;
  String userId;
  String hostName;
  String? avatar;
  int likesCount;
  int commentsCount;
  String roomId;
  String roomName;
  int tag;
  List<String>? imageUrls;
  List<String>? likedBy;
  DateTime createdAt;

  Post({
    required this.id,
     this.caption,
    required this.userId,
    required this.hostName,
    this.avatar,
    required this.likesCount,
    required this.commentsCount,
    required this.roomId,
    required this.roomName,
    required this.tag,
    this.imageUrls ,
    this.likedBy,
    required this.createdAt
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<dynamic> imageUrlsJson = json['imageUrls'];
    List<dynamic> likedByJson = json['likedBy'];

    return Post(
      id: json['id'],
      caption: json['caption'],
      userId: json['userId'],
      hostName: json['hostName'],
      avatar: json['avatar'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      roomId: json['roomId'],
      roomName: json['roomName'],
      tag: json['tag'],
      imageUrls: imageUrlsJson.map((url) => url.toString()).toList(),
      likedBy: likedByJson.map((userId) => userId.toString()).toList(),
      createdAt:  DateTime.parse(json['createdAt'])
    );
  }
}
