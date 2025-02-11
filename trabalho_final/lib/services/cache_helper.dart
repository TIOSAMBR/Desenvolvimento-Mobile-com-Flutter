import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trabalho_final/models/noticia_model.dart';

class CacheHelper {
  static const String _cacheKey = 'noticias_cache';

  // Salvar notícias no cache 
  static Future<void> salvarNoticias(List<Noticia> noticias) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (noticias.length > 100) {
      noticias = noticias.sublist(0, 100);
    }

    List<String> noticiasJson = noticias.map((noticia) => json.encode(noticia.toMap())).toList();
    await prefs.setStringList(_cacheKey, noticiasJson);
  }

  static Future<List<Noticia>> obterNoticias() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? noticiasJson = prefs.getStringList(_cacheKey);

    if (noticiasJson != null) {
      return noticiasJson.map((jsonStr) {
        return Noticia.fromJson(json.decode(jsonStr));
      }).toList();
    } else {
      return [];
    }
  }

  static Future<void> limparCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
