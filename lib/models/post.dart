class Post {
  String id;
  String title;
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
  bool isHiddenHost;
  Post(
      {required this.id,
      required this.title,
      this.caption,
      required this.userId,
      required this.hostName,
      this.avatar,
      required this.likesCount,
      required this.commentsCount,
      required this.roomId,
      required this.roomName,
      required this.tag,
      this.imageUrls,
      this.likedBy,
      required this.createdAt,
      required this.isHiddenHost});

  factory Post.fromJson(Map<String, dynamic> json) {
    List<dynamic> imageUrlsJson = json['imageUrls'];
    List<dynamic> likedByJson = json['likedBy'];

    return Post(
        id: json['_id'],
        title: json['title'],
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
        createdAt: DateTime.parse(json['createdAt']),
        isHiddenHost:json['isHiddenHost']);
  }
}
