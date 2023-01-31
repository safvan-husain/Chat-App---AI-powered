import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      username: map['username'],
      email: map['email'],
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
    };
  }
}
