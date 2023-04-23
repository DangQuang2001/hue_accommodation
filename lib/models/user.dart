class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String image;
  final String phone;
  final String address;
  final bool isGoogle;
  final bool isHost;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    required this.phone,
    required this.address,
    required this.isGoogle,
    required this.isHost,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
      phone: json['phone'],
      address: json['address'],
      isGoogle: json['isGoogle'],
      isHost: json['isHost'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'password':password,
    'image': image,
    'phone': phone,
    'address':address,
    'isGoogle': isGoogle,
    'isHost': isHost,
  };
}