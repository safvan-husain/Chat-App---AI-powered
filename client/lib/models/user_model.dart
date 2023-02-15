// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  bool isOnline;
  final String? avatar;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.isOnline,
    this.avatar,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'],
      username: map['username'],
      email: map['email'],
      isOnline: map['isOnline'],
      avatar: map['avatar'],
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
      'isOnline': isOnline,
      'avatar': avatar,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    bool? isOnline,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isOnline: isOnline ?? this.isOnline,
      avatar: avatar ?? this.avatar,
    );
  }
}
