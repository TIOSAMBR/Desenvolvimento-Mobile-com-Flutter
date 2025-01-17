import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final response = await http.get(Uri.parse('$_baseUrl/users?username=$username'));

    if (response.statusCode == 200) {
      final users = jsonDecode(response.body);
      if (users.isNotEmpty) {
        return users[0]; // Retorna o primeiro usuário encontrado
      }
    }
    return null;
  }

  static Future<List<dynamic>> getPostsByUserId(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/posts?userId=$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<List<dynamic>> getCommentsByPostId(int postId) async {
    final response = await http.get(Uri.parse('$_baseUrl/comments?postId=$postId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
