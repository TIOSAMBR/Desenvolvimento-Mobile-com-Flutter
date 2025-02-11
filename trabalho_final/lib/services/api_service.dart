import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia_model.dart';

class ApiService {
  static const String baseUrl = 'http://157.245.254.121';

  static Future<List<Noticia>> fetchNoticias(int pagina) async {
    final response = await http.get(Uri.parse('$baseUrl/noticias?page=$pagina'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar notícias');
    }
  }
}