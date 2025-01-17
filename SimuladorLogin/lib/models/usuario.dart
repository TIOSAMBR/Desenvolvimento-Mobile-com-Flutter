import 'dart:convert';

class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory User.fromJson(String source) {
    final data = jsonDecode(source);
    return User(
      id: data['id'],
      name: data['name'],
      username: data['username'],
      email: data['email'],
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'name': name,
      'username': username,
      'email': email,
    });
  }
}
