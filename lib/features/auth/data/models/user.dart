import 'dart:convert';

class UserModel {
  final String? id;
  final String? username;
  final String? email;
  final DateTime? createdAt;
  final int? avatarIndex;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.createdAt,
    this.avatarIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': createdAt,
      'avatarIndex': avatarIndex,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      createdAt: map['createdAt']?.toDate(),
      avatarIndex: map['avatarIndex'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    DateTime? createdAt,
    int? avatarIndex,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }
}
