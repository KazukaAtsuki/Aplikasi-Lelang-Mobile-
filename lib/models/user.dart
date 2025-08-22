class User {
  final int id;
  final String avatar;
  final String name;
  final String email;
  final String role;
  final String? token;

  User({
    required this.id,
    required this.avatar,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  // JSON → User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: json['token'],
    );
  }

  // User → JSON (jika mau kirim balik ke API)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "avatar": avatar,
      "name": name,
      "email": email,
      "role": role,
      "token": token,
    };
  }
}
