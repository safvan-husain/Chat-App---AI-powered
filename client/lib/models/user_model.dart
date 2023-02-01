import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  bool isOnline;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isOnline,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      username: map['username'],
      email: map['email'],
      isOnline: map['isOnline'],
    );
  }
  factory User.fromJson(String json) {
    return User.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isOnline': isOnline
    };
  }
}
